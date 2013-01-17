# Camera description
class Camera extends NativeObject
  # ### Steroids.camera.flash
  #
  # Singleton representing the flash torch of the device
  #
  flash: new Flash


  takePicture: (options={}, callbacks={})->
    # because native returns wtf path
    pathFixWrapperCallback = (data)->
      data.imagePath = "../../"+data.imagePath
      callbacks.onSuccess data

    @nativeCall
      method: "takePicture"
      parameters:
        filenameWithPath: options.file
      successCallbacks: [pathFixWrapperCallback]
      failureCallbacks: [callbacks.onFailure]


  choosePicture: (options={}, callbacks={})->
    options.dialogTitle ?= "Select source"
    options.cancelButtonText ?= "Cancel"
    options.cameraButtonText ?= "Open Camera"
    options.libraryButtonText ?= "Choose From Library"

    # because native returns wtf path
    pathFixWrapperCallback = (data)->
      data.imagePath = "../../"+data.imagePath
      callbacks.onSuccess data

    @nativeCall
      method: "choosePicture"
      parameters:
        filenameWithPath: options.file
        cameraButtonTitle: options.cameraButtonText
        libraryButtonTitle: options.libraryButtonText
        cancelButtonTitle: options.cancelButtonText
        dialogTitle: options.dialogTitle
      successCallbacks: [pathFixWrapperCallback]
      failureCallbacks: [callbacks.onFailure]

