import State from "./state"
import objectLibrary from "./objects/import"
import $ from 'jquery'


var PIXEL_RATIO = function() {


}


class Draw {
  constructor(config, objectLibrary) {
    this.container = $(config.container)

    $(this.container).append("<canvas class='main-canvas'>You do not have support for HTML5 Canvas</canvas>")
    this.canvas = $(config.container + ' canvas.main-canvas')[0]

    $(this.container).append("<div class='canvas-buffer' style='display: none;'></div>")
    this.buffer = $(config.container + ' .canvas-buffer')[0]

    this.tmpObjectId = undefined
    this.tmpObject = undefined
    this.tmpObjectLibrary = undefined
    this.tmpAllObjects = undefined
    this.tmpBufferObject = undefined
    this.buffers = []
    this.i = 0

    this.state = new State(objectLibrary)

    this.baseFont = config.baseFont || '16px sans serif'
    this.context = this.canvas.getContext('2d')

    if (config.resolution === undefined) {

    let dpr = window.devicePicelRatio || 1
    let bsr = this.context.webkitBackingStorePixelRatio ||
               this.context.mozBackingStorePixelRatio ||
               this.context.msBackingStorePixelRatio ||
               this.context.oBackingStorePixelRatio ||
               this.context.backingStorePixelRatio || 1

    this.ratio = this.dpr / this.bsr

    }else{
      this.ratio = config.resolution
    }

    this.canvas.height = this.container.height() * this.ratio
    this.canvas.width = this.container.width() * this.ratio

    this.canvas.style.height = this.container.height() + "px"
    this.canvas.style.width = this.container.width() + "px"
    this.context.setTransform(this.ratio, 0, 0, this.ratio, 0, 0)
  }

  redraw() {
    this.context.font = this.baseFont
    this.context.clearRect(0, 0, this.context.width, this.context.height);
    this.tmpAllObjects = this.state.readAll()
    for (this.tmpObjectId in this.tmpAllObjects) {
      this.tmpObject = this.tmpAllObjects[this.tmpObjectId]
      if (this.tmpObject === undefined) {
        continue
      }
      console.log("RENDERING -> " + JSON.stringify(this.tmpObject))
      this.render()
    }
  }

  insert(type, data) {
    this.tmpObjectId = this.state.create(type, data)
    if (this.tmpObjectId < 0) {
      return false
    }else{
      this.redraw()
    }
  }

  delete(id) {

  }

  insertBufferCanvas() {
    if ($(this.buffer).find(".buffer-canvas-id-" + this.tmpObjectId + "'")) {
      return;
    }
    this.tmpBufferObject = $("<canvas class='buffer-canvas-id-" + this.tmpObjectId + "'>You do not have support for HTML5 Canvas</canvas>")
    $(this.buffer).append(this.tmpBufferObject)
    this.tmpBufferObject[0].getContext('2d')
    this.buffers.push(this.tmpObjectId)
  }

  render() {
    if (this.buffers.indexOf(this.tmpObjectId) < 0) {

      switch (this.tmpObject.type) {
        case "text":
          this.tmpObjectLibrary = objectLibrary.text
          this.insertBufferCanvas()
          break;
        default:
          return false
      }
      console.log("RENDERING")

      this.tmpObjectLibrary.render(this.tmpObject, this.context)
    }else{
      this.tmpBufferObject = $(this.buffer).find(".buffer-canvas-id-" + this.tmpObjectId + "'")[0]
      this.context.drawImage(this.tmpBufferObject)
    }
  }
}

export default Draw
