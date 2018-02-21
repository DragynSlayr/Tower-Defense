require "logic.constants"
require "logic.globals"

queue = {}
size = 0
elements = 0
max_size = 0
speed = Screen_Size.width / 3

love.update = (dt) ->
  size += speed * dt
  if size >= max_size
    size = max_size
    if #queue > 0
      require table.remove queue, 1
      max_size = Screen_Size.width * (1 - (#queue / elements))
    else
      queue = nil
      export ResoureLoader = ResoureCacher!
      export Driver = Driver!
      Driver.load!

love.draw = () ->
  love.graphics.push "all"
  love.graphics.setColor 0, 0, 0, 255
  love.graphics.rectangle "fill", 0, 0, Screen_Size.width, Screen_Size.height
  love.graphics.setColor 75, 163, 255, 255
  love.graphics.rectangle "fill", (Screen_Size.width - size) / 2, 0, size, Screen_Size.height
  love.graphics.setColor 255, 255, 255, 255
  text = size / Screen_Size.width
  text = math.floor text * 100
  love.graphics.printf "Loading " .. text .. "%\t", 0, Screen_Size.height - (25 * Scale.height), Screen_Size.width, "right"
  love.graphics.pop!

love.load = () ->
  queue = require "logic.classLoader"
  elements = #queue
  export VERSION = "V.46"
