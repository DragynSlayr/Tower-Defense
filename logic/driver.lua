do
  local _class_0
  local _base_0 = {
    keypressed = function(key, scancode, isrepeat)
      if key == "escape" then
        return love.event.quit()
      else
        return Player:keypressed(key)
      end
    end,
    keyreleased = function(key)
      Player:keyreleased(key)
    end,
    mouspressed = function(x, y, button, isTouch) end,
    mousereleased = function(x, y, button, isTouch) end,
    focus = function(focus) end,
    load = function(arg)
      Renderer:add(Player, 1)
    end,
    update = function(dt)
      Player:update(dt)
    end,
    draw = function()
      love.graphics.push("all")
      Renderer:drawAll()
      love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      love.keypressed = self.keypressed
      love.keyreleased = self.keyreleased
      love.mousepressed = self.mousepressed
      love.mousereleased = self.mousereleased
      love.focus = self.focus
      love.load = self.load
      love.update = self.update
      love.draw = self.draw
    end,
    __base = _base_0,
    __name = "Driver"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Driver = _class_0
end
