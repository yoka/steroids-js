# Communication bridge that utilizes a websocket through the network layer
class WebsocketBridge extends Bridge
  constructor: ()->
    steroids.debug "Initializing WebsocketBridge"

  @isUsable: ()->
    true

  # Open WebSocket connection to Native
  reset: ()->
    steroids.waitForComponent "WebSocket", "websocketUsable"
    steroids.debug "resetting websocket to port #{AG_WEBSOCKET_PORT}"
    @websocket = new WebSocket "ws://localhost:#{AG_WEBSOCKET_PORT}"
    @websocket.onmessage = @message_handler
    # @websocket.onclose = ()=>
    #   Steroids.debug "websocket closed"
    #   if Steroids.websocketUsableHasFired
    #     Steroids.debug "resetting websocket due to closed"
    #     @reset()
    @websocket.addEventListener "open", ()=>
      steroids.debug "websocket is now open"

      @websocket.send JSON.stringify(@prepareMessage({method:"mapWebSocketConnectionToContext", parameters: {}}))

      steroids.markComponentReady "WebSocket", "websocketUsable"

    return false

  sendMessageToNative:(message)->
    steroids.debug "Queueing API call: #{message}"
    steroids.on "websocketUsable", ()=>
      steroids.debug "Sending API call: #{message}"
      steroids.nativeBridge.websocket.send message

  message_handler: (e)=>
    super(e.data)
