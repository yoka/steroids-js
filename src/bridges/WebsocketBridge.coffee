# Communication bridge that utilizes a websocket through the network layer
class WebsocketBridge extends Bridge
  constructor: ()->
    Steroids.debug "Initializing WebsocketBridge"

  @isUsable: ()->
    true

  # Open WebSocket connection to Native
  reset: ()->
    Steroids.waitForComponent "WebSocket", "websocketUsable"
    Steroids.debug "resetting websocket to port #{AG_WEBSOCKET_PORT}"
    @websocket = new WebSocket "ws://localhost:#{AG_WEBSOCKET_PORT}"
    @websocket.onmessage = @message_handler
    # @websocket.onclose = ()=>
    #   Steroids.debug "websocket closed"
    #   if Steroids.websocketUsableHasFired
    #     Steroids.debug "resetting websocket due to closed"
    #     @reset()
    @websocket.addEventListener "open", ()=>
      Steroids.debug "websocket is now open"

      @websocket.send JSON.stringify(@prepareMessage({method:"mapWebSocketConnectionToContext", parameters: {}}))

      Steroids.markComponentReady "WebSocket", "websocketUsable"

    return false

  sendMessageToNative:(message)->
    Steroids.debug "Queueing API call: #{message}"
    Steroids.on "websocketUsable", ()=>
      Steroids.debug "Sending API call: #{message}"
      Steroids.nativeBridge.websocket.send message

  message_handler: (e)=>
    super(e.data)
