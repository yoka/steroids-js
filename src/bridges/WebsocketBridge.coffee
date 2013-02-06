# Communication bridge that utilizes a websocket through the network layer
class WebsocketBridge extends Bridge
  constructor: ()->
    if window._steroidsNativeReady?
      # Use reopen to open WebSocket
      @reopen()

  @isUsable: ()->
    true

  reset: ()->
    unless @websocket?
      @reopen()
      Steroids.markComponentReady("Bridge")

  # Open WebSocket connection to Native
  reopen: ()=>
    @websocket = new WebSocket "ws://localhost:#{AG_WEBSOCKET_PORT}"
    @websocket.onmessage = @message_handler
    @websocket.onclose = @reopen
    @websocket.addEventListener "open", @map_context
    @map_context()
    return false

  # Map current context so that native calls know where to send responses
  map_context: ()=>
    @send method: "mapWebSocketConnectionToContext"

    return @

  sendMessageToNative:(message)->
    unless @websocket?
      Steroids.on "ready", ()=>
        @websocket.send message
    else
      if @websocket.readyState is 0
        @websocket.addEventListener "open", ()=>
          @websocket.send message
      else
        @websocket.send message

  message_handler: (e)=>
    super(e.data)
