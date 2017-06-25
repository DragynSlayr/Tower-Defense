require "logic.constants"
require "logic.globals"

queue = {}
size = 0
elements = 0

love.update = (dt) ->
  if #queue > 0
    require table.remove queue, 1
    size = Screen_Size.width * (1 - (#queue / elements))
  else
    queue = nil
    export Driver = Driver!
    Driver.load!

love.draw = () ->
  love.graphics.push "all"
  love.graphics.setColor 0, 0, 0, 255
  love.graphics.rectangle "fill", 0, 0, Screen_Size.width, Screen_Size.height
  love.graphics.setColor 75, 163, 255, 255
  love.graphics.rectangle "fill", (Screen_Size.width - size) / 2, 0, size, Screen_Size.height
  love.graphics.pop!

love.load = () ->
  queue = require "logic.classLoader"
  elements = #queue
  export VERSION = "V.11B"
