require("logic.constants")
require("logic.globals")
local queue = { }
local size = 0
local elements = 0
local max_size = 0
local speed = Screen_Size.width / 3
love.update = function(dt)
  size = size + (speed * dt)
  if size >= max_size then
    size = max_size
    if #queue > 0 then
      require(table.remove(queue, 1))
      max_size = Screen_Size.width * (1 - (#queue / elements))
    else
      queue = nil
      ResoureLoader = ResoureCacher()
      Driver = Driver()
      return Driver.load()
    end
  end
end
love.draw = function()
  love.graphics.push("all")
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.rectangle("fill", 0, 0, Screen_Size.width, Screen_Size.height)
  love.graphics.setColor(75, 163, 255, 255)
  love.graphics.rectangle("fill", (Screen_Size.width - size) / 2, 0, size, Screen_Size.height)
  love.graphics.setColor(255, 255, 255, 255)
  local text = size / Screen_Size.width
  text = math.floor(text * 100)
  love.graphics.printf("Loading " .. text .. "%\t", 0, Screen_Size.height - (25 * Scale.height), Screen_Size.width, "right")
  return love.graphics.pop()
end
love.load = function()
  queue = require("logic.classLoader")
  elements = #queue
  VERSION = "V.29"
end
