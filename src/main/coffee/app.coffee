###
  using App.WebSocket api
###

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
  frontend part

  for the development purpose and better dom manipulation, use jquery, knockout or other library / framework..
###

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

$('#conversationDiv').submit (event) ->
  event.preventDefault()
  sendMessage()

###
  using App.Rest api
###

###
  on load body

  initialize app page
###
$('body').ready ->
  $('#form').fadeIn 'fast'

###
  this is how we will open connection

  before sending or for subscribing on the messages you must connect to the Stomp endpoint
  after that, we will render initial page and subscribe for welcome messages
###
$('#connect').click ->
  unless Api.WebSocket.isConnected()
    Api.WebSocket.connect (frame) ->
      Api.WebSocket.setConnected true

      $('#conversationDiv').toggle 'fast'
      $('#response').fadeIn 'fast'
      $('#connect').prop('disabled', yes).toggle 'fast'
      $('#disconnect').prop('disabled', no).toggle 'fast'
      $('#message').focus()

      Api.WebSocket.subscribe (welcome) ->
        render(welcome)

###
  this is how we disconnect from the server
###
$('#disconnect').click ->
  if Api.WebSocket.isConnected()
    Api.WebSocket.disconnect()

  $('#conversationDiv').toggle 'fast'
  $('#connect').prop('disabled', no).toggle 'fast'
  $('#disconnect').prop('disabled', yes).toggle 'fast'

###
  this is how we do login with username and password

  in our case token it's just a password, but it will fully validate on backend
  TODO: handle login error
###
$('#form').submit (event) ->
  event.preventDefault()

  form = $ @
  username = $('#username').val()
  password = $('#password').val()
  $.when(Api.Rest.auth username, password).then ->
    $.when Api.Rest.getUsers (data) ->
      $('#connect').click()
      form.toggle('fast').find('input').val('')
      $('#logout').prop('disabled', no).toggle 'fast'
      $('#users').html ''
      appendUser(user) for user in data._embedded.users

appendUser = (user) ->
  div = $('<div>').append user.username
  $('#users').append(div).fadeIn 'fast'

###
  this is how we logout
###
$('#logout').click ->
  Api.Rest.logout()

  form = $('#form')
  form.fadeIn 'fast'
  form.find('input#username').focus()

  $('#logout').fadeOut 'fast'
  $('#users').toggle('fast')