###
  sigma gambling platform api
###
class @Api

  ###
    platform configuration
  ###
  apiConfig =
    debug: no

  ###
    get debug mode on true if enabled
  ###
  @debugModeOn = ->
    apiConfig.debug

  ###
    api to work with platform WebSocket services
  ###
  class @WebSocket
    stompClient = null

    ###
      web socket services configuration
    ###
    webSocketConfig =
      connected: false
      sockJs:
        url: '/ws/url/welcome'
      stomp:
        subscribe:
          url: '/ws/topic/welcome'
        app:
          url: '/app/ws/url/welcome'

    ###
      connect to the SockJs endpoint
    ###
    @connect = (func) ->
      console.log "connecting to the #{webSocketConfig.sockJs.url} ..." if apiConfig.debug

      socket = new SockJS webSocketConfig.sockJs.url
      stompClient = Stomp.over socket
      stompClient.connect {}, func

    ###
      connected getter
    ###
    @isConnected = ->
      webSocketConfig.connected

    ###
      connected setter
    ###
    @setConnected = (current) ->
      webSocketConfig.connected = current

    ###
      disconnect web socket session
    ###
    @disconnect = ->
      stompClient?.disconnect()
      webSocketConfig.connected = false
      console.log "disconnected" if apiConfig.debug

    ###
      subscribe for Stomp messages
    ###
    @subscribe = (func) ->
      stompClient.subscribe webSocketConfig.stomp.subscribe.url, func

    ###
      send messages to the application messaging service
    ###
    @send = (message) ->
      stompClient.send webSocketConfig.stomp.app.url, {}, message

  ###
    api to work with platform rest services
  ###
  class @Rest

    ###
      rest services configuration
    ###
    restConfig =
      csrf: ''
      auth:
        username: ''
        token: ''
      http:
        url:
          csrf: '/csrf'
        method:
          get: 'GET'
          post: 'POST'

    ###
      fetch actual CSRF
    ###
    @getCsrf = ->
      $.ajax
        url: restConfig.http.url.csrf
        type: restConfig.http.method.get
        success: (data, status, xhr) ->
          restConfig.csrf = data
        error: (xhr, status, err) ->
          console.log status, err
        complete: (xhr, status) ->
          console.log 'complete' if apiConfig.debug