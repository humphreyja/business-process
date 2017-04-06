import Draw from "./canvas/draw"
import config from "./canvas/config"
import objectLibrary from "./canvas/objects/import"

let draw = new Draw(config, objectLibrary)


draw.insert("text", {text: "Sample Text", x: 10, y: 40})
