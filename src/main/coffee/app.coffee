###
  using App.WebSocket api
###

###
  this is how we will open connection
  
  before sending or for subscribing on the messages you must connect to the Stomp endpoint
  after that, we will render initial page and subscribe for welcome messages
###
connect = ->
  unless Api.WebSocket.isConnected()
    Api.WebSocket.connect (frame) ->
      Api.WebSocket.setConnected true
      reset()
      Api.WebSocket.subscribe (welcome) ->
        render(welcome)

###
  this is how we send outbound stomp message to the endpoint
###
sendName = ->
  name = document.getElementById('name').value
  Api.WebSocket.send JSON.stringify(name: name)
  document.getElementById('name').value = ''

###
  this is how we disconnect from the server
###
disconnect = ->
  if Api.WebSocket.isConnected()
    Api.WebSocket.disconnect()
  reset()

###
  frontend part

  for the development purpose and better dom manipulation, use jquery, knockout or other library / framework..
###

###
  just frontend: reset page area on connect or disconnect
###
reset = ->
  document.getElementById('connect').disabled = Api.WebSocket.isConnected();
  document.getElementById('disconnect').disabled = not Api.WebSocket.isConnected();
  if Api.WebSocket.isConnected()
    document.getElementById('conversationDiv').style.visibility = 'visible'
  else
    document.getElementById('conversationDiv').style.visibility = 'hidden'
  document.getElementById('response').innerHTML = ''

###
  just frontend: render received message
###
render = (welcome) ->
  message = JSON.parse(welcome.body).content
  response = document.getElementById 'response'
  p = document.createElement 'p'
  p.style.wordWrap = 'break-word'
  p.appendChild(document.createTextNode message)
  response.appendChild p

###
  using App.Rest api
###

###
  this is how we login with username and auth token

  in our case token it's just a password, but it will fully validate on backend
###
