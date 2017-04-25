do
  local _class_0
  local _base_0 = {
    addObject = function(self, object, id)
      if self.objects[id] then
        self.objects[id][#self.objects[id] + 1] = object
        return Renderer:add(object, EntityTypes.layers[id])
      else
        self.objects[id] = { }
        return self:addObject(object, id)
      end
    end,
    keypressed = function(key, scancode, isrepeat)
      if key == "escape" then
        return love.event.quit()
      else
        for k, v in pairs(Driver.objects[EntityTypes.player]) do
          v:keypressed(key)
        end
      end
    end,
    keyreleased = function(key)
      for k, v in pairs(Driver.objects[EntityTypes.player]) do
        v:keyreleased(key)
      end
    end,
    mouspressed = function(x, y, button, isTouch) end,
    mousereleased = function(x, y, button, isTouch) end,
    focus = function(focus) end,
    load = function(arg) end,
    update = function(dt)
      for k, v in pairs(Driver.objects) do
        for k2, o in pairs(v) do
          o:update(dt)
          if o.health <= 0 then
            v[k2]:kill()
            v[k2] = nil
          end
        end
      end
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
      self.objects = { }
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
