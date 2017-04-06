class State {
  constructor(objectLibrary) {
    this.objects = {}
    this.index = 0
    this.tmp_library = {}
    this.tmp_object = {}
    this.objectLibrary = objectLibrary
  }

  read(id) {
    return this.objects[id]
  }

  readAll() {
    return this.objects
  }

  create(type, data) {
    switch (type) {
      case "text":
        this.tmp_library = this.objectLibrary.text
        break
      default:
        return -1
    }

    console.log(JSON.stringify(this.objectLibrary.text))

    this.objects[this.index++] = this.tmp_library.update(this.tmp_library.object, data)
    return this.index;
  }

  update(id, data) {
    this.tmp_object = this.object[id]
    if (this.tmp_object === undefined) {
      return false
    }
    switch (this.tmp_object.type) {
      case "text":
        this.tmp_library = this.objectLibrary.text
        break;
      default:
        return false
    }

    return this.tmp_library.update(this.tmp_object, data)
  }

  delete(id) {
    return delete this.objects[id]
  }
}

export default State
