###
  Frontend application (example of using App.WebSocket API)

  for development purpose and better DOM manipulation, use jquery, knockout or other library / framework..
###

# open connection, render initial page and subscribe for welcome messages
connect = ->
  unless Api.WebSocket.isConnected()
    Api.WebSocket.connect (frame) ->
      Api.WebSocket.setConnected true
      render()
      Api.WebSocket.subscribe (welcome) ->
        publisher(welcome)

# clear page area (using on connect or disconnect)
render = ->
  document.getElementById('connect').disabled = Api.WebSocket.isConnected();
  document.getElementById('disconnect').disabled = not Api.WebSocket.isConnected();
  if Api.WebSocket.isConnected()
    document.getElementById('conversationDiv').style.visibility = 'visible'
  else
    document.getElementById('conversationDiv').style.visibility = 'hidden'
  document.getElementById('response').innerHTML = ''

# render input message from broker
publisher = (welcome) ->
  message = JSON.parse(welcome.body).content
  response = document.getElementById 'response'
  p = document.createElement 'p'
  p.style.wordWrap = 'break-word'
  p.appendChild(document.createTextNode message)
  response.appendChild p

# send message to the broker via stomp endpoint
sendName = ->
  name = document.getElementById('name').value
  Api.WebSocket.send JSON.stringify(name: name)
  document.getElementById('name').value = ''

# close connection and render initial page
disconnect = ->
  if Api.WebSocket.isConnected()
    Api.WebSocket.disconnect()
  render()