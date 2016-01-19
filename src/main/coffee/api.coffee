###
  platform api
###
class @Api

  ###
    platform configuration
  ###
  apiConfig =
    debug: yes

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
      authHeaders: null
      http:
        url:
          csrf: '/csrf'
          users: '/api/users'
        method:
          get: 'GET'
          post: 'POST'

    ###
      get username
    ###
    @getUsername = ->
      if restConfig.authHeaders? then restConfig.authHeaders.username else 'anonymous'

    ###
      fetch and store auth token, username and actual CSRF

      params:
        username:
          require: username
        password:
          require: password
    ###
    @auth = (username, password) ->
      # fetch csrf and store it with username and password into auth headers
      $.ajax
        url: restConfig.http.url.csrf
        type: restConfig.http.method.get
        error: (xhr, status, err) ->
          console.error status, err
        complete: (xhr, status) ->
          console.log 'complete' if Api.debugModeOn()
        success: (data, status, xhr) ->
          # store username and token TODO: should be fetched from secured auth token service
          restConfig.authHeaders =
            'X-CSRF-TOKEN': data.token
            username: username
            token: password

    ###
      logout

      clearing auth headers
    ###
    @logout = ->
      restConfig.authHeaders = null

    ###
      get all users

      params:
        handler:
          required: callback function to process result if handler exists (optional)
    ###
    @getUsers = (handler) ->
      console.log 'headers', restConfig.authHeaders
      $.ajax
        url: restConfig.http.url.users
        type: restConfig.http.method.get
        headers: restConfig.authHeaders
        success: (data) ->
          handler data
