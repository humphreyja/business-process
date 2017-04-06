let text = {}

text.object = {
  type: "text",
  text: "",
  x: 0,
  y: 0
}

text.render = function(object, context) {
  context.fillText(object.text, object.x, object.y)
  return true;
}

text.update = function(object, data) {
  if (data.text !== undefined) {
    object.text = data.text
  }

  if (data.x !== undefined) {
    object.x = data.x
  }

  if (data.y !== undefined) {
    object.y = data.y
  }

  return object
}

export default text
