window.steroids =
  debugEnabled: false
  eventCallbacks: {}
  waitingForComponents:
    ready: ["NativeReady"]

  debug: (msg)->
    console.log msg if @debugEnabled

  on: (event, callback)->
    if @["#{event}HasFired"]? && @["#{event}HasFired"] == true
      @debug "#{event} has fired, instacallbacking #{callback}"
      callback()
    else
      @debug "#{event} not yet fired, storing callback #{callback}"
      @eventCallbacks[event] ||= []
      @eventCallbacks[event].push(callback)
      @debug "#{event} now has #{@eventCallbacks[event].length} callbacks"


  fireSteroidsEvent: (event)->
    @debug "firing #{event}"
    @["#{event}HasFired"] = true

    if @eventCallbacks[event]?
      @debug "firing #{@eventCallbacks[event].length} callbacks"
      for callback in @eventCallbacks[event]
        @debug "firing callback: #{callback}"
        callback() if callback?
        @eventCallbacks[event].splice @eventCallbacks[event].indexOf(callback), 1

      @debug "callback queue for #{event} has now #{@eventCallbacks[event].length} callbacks"


  markComponentReady: (model, event="ready")->
    return unless @waitingForComponents[event]?
    return if @waitingForComponents[event].indexOf(model) == -1

    @debug "marking #{model} #{event}"
    @waitingForComponents[event].splice @waitingForComponents[event].indexOf(model), 1
    if @waitingForComponents[event].length == 0
      @debug "marked #{model} #{event}, firing #{event}"
      @fireSteroidsEvent event
    else
      @debug "still waiting for #{JSON.stringify @waitingForComponents[event]}"

  waitForComponent: (model, event="ready")->
    @debug "waiting for #{model} for event #{event}"
    @["#{event}HasFired"] = false
    @waitingForComponents[event] ||= []
    @waitingForComponents[event].push model

  nativeReady: ()->
    @debug "received nativeReady"
    @nativeBridge.reset()
    @markComponentReady "NativeReady"

# Communication endpoint to native API
# Native bridge is the communication layer from WebView to Native
# Valid values are subclasses of Bridge
window.steroids.nativeBridge = Bridge.getBestNativeBridge()

if window._steroidsNativeReady?
  window.steroids.debug "nativeready has fired before steroids init"
  window.steroids.nativeReady()

# Current version
window.steroids.version = "@@version"

window.steroids.views = {}
window.steroids.views.WebView = WebView

# Public Tab class
window.steroids.Tab = Tab

# Public OAuth2 class
window.steroids.OAuth2 = OAuth2

# Public Animation singleton

window.steroids.Animation = new Animation  # to be deprecated, not documented
window.steroids.animation = window.steroids.Animation

# Public LayerCollection singleton
window.steroids.layers = new LayerCollection

# Current view
window.steroids.view = new steroids.views.WebView { location: window.location.href }

# Public Modal singleton
window.steroids.modal = new Modal

# Public Audio singleton
window.steroids.audio = new Audio

# Public Camera singleton
window.steroids.camera = new Camera

# Public NavigationBar singleton
window.steroids.navigationBar = new NavigationBar

# Public App singleton
window.steroids.app = new App

# Public Device singleton
window.steroids.device = new Device

window.steroids.data = {}
window.steroids.data.TouchDB = TouchDB

window.steroids.XHR = XHR

window.steroids.analytics = new Analytics
