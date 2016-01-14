stompClient = null

setConnected = (connected) ->
  document.getElementById('connect').disabled = connected;
  document.getElementById('disconnect').disabled = not connected;
  if connected
    document.getElementById('conversationDiv').style.visibility = 'visible'
  else
    document.getElementById('conversationDiv').style.visibility = 'hidden'
  document.getElementById('response').innerHTML = ''

connect = ->
  socket = new SockJS '/ws/url/welcome'
  stompClient = Stomp.over socket
  stompClient.connect {}, (frame) ->
    setConnected true
    console.log "Connected: #{frame}"
    stompClient.subscribe '/ws/topic/welcome', (welcome) ->
      showWelcome(JSON.parse(welcome.body).content)

disconnect = ->
  stompClient?.disconnect()

  setConnected false
  console.log "Disconnected"

sendName = ->
  name = document.getElementById('name').value
  stompClient.send "/app/ws/url/welcome", {}, JSON.stringify(name: name)
  document.getElementById('name').value = ''

showWelcome = (message) ->
  response = document.getElementById 'response'
  p = document.createElement 'p'
  p.style.wordWrap = 'break-word'
  p.appendChild(document.createTextNode message)
  response.appendChild p