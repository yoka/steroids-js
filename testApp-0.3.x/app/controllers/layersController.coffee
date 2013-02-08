class window.LayersController

  @testPushPop: () ->
    pushed = () ->
      console.log "PUSHED"

    popView = new steroids.views.WebView {
      location: "/views/layers/pop.html"
    }

    steroids.layers.push {
      layer: popView
    }, {
      onSuccess: pushed
    }

  @testPop: () ->
    popped = () ->
      alert "popped"

    steroids.layers.pop()

Steroids.on "ready", ->
  Steroids.navigationBar.show title: "LAYERS"

Steroids.on "ready", ->
  Steroids.audio.prime()

