###
  Provided API to work with WebSockets and REST
###

class @Api

  class @WebSocket
    stompClient = null

    config =
      debug: no
      connected: false
      sockJs:
        url: '/ws/url/welcome'
      stomp:
        subscribe:
          url: '/ws/topic/welcome'
        app:
          url: '/app/ws/url/welcome'

    ### getters, setters, API ###

    @connect = (func) ->
      console.log "connecting to the #{config.sockJs.url} ..." if config.debug

      socket = new SockJS config.sockJs.url
      stompClient = Stomp.over socket
      stompClient.connect {}, func

    @isConnected = ->
      config.connected

    @setConnected = (current) ->
      config.connected = current

    @disconnect = ->
      stompClient?.disconnect()
      config.connected = false
      console.log "disconnected" if config.debug

    @subscribe = (func) ->
      stompClient.subscribe config.stomp.subscribe.url, func

    @send = (message) ->
      stompClient.send config.stomp.app.url, {}, message

  class @Rest