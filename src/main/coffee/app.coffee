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
sendMessage = ->
  message = $('#message').val()

  Api.WebSocket.send JSON.stringify
    username: Api.Rest.getUsername()
    message: message

  $('#message').val ''

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
  $('#connect').prop 'disabled', Api.WebSocket.isConnected()
  $('#disconnect').prop 'disabled', not Api.WebSocket.isConnected()

  if Api.WebSocket.isConnected()
    $('#conversationDiv').attr 'style', 'visibility: visible'
  else
    $('#conversationDiv').attr 'style', 'visibility: hidden'

  $('#response').html ''

###
  just frontend: render received message
###
render = (welcome) ->
  message = JSON.parse(welcome.body).message.message
  username = JSON.parse(welcome.body).message.username

  p = $ '<p>'
  p.css 'wordWrap', 'break-word'
  p.append "#{username}: #{message}"

  response = $ '#response'
  response.prepend p

$('#connect').click ->
  connect()

$('#disconnect').click ->
  disconnect()

$('#conversationDiv').submit (event) ->
  event.preventDefault()
  sendMessage()

###
  using App.Rest api
###

###
  this is how we do login with username and password

  in our case token it's just a password, but it will fully validate on backend
###
$('#form').submit (event) ->
  event.preventDefault()

  username = $('#username').val()
  password = $('#password').val()
  self = $ @
  $.when(Api.Rest.auth username, password)
    .then ->
      $.when Api.Rest.getUsers (data) ->
        self.toggle 'fast'
        $('#connect').click()
        appendUser(user) for user in data._embedded.users

appendUser = (user) ->
  div = $('<div>')
  div.append user.username
  $('#users').append(div).hide().fadeIn 'fast'