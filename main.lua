require("logic.constants")
require("logic.globals")
local queue = { }
local size = 0
local elements = 0
love.update = function(dt)
  if #queue > 0 then
    require(table.remove(queue, 1))
    size = Screen_Size.width * (1 - (#queue / elements))
  else
    queue = nil
    Driver = Driver()
    return Driver.load()
  end
end
love.draw = function()
  love.graphics.push("all")
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.rectangle("fill", 0, 0, Screen_Size.width, Screen_Size.height)
  love.graphics.setColor(75, 163, 255, 255)
  love.graphics.rectangle("fill", (Screen_Size.width - size) / 2, 0, size, Screen_Size.height)
  return love.graphics.pop()
end
love.load = function()
  queue = require("logic.classLoader")
  elements = #queue
  VERSION = "V.11B"
end
