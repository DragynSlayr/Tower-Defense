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
    removeObject = function(self, object)
      for k, v in pairs(Driver.objects) do
        for k2, o in pairs(v) do
          if object == o then
            Renderer:removeObject(object)
            v[k2]:kill()
            Objectives:entityKilled(v[k2])
            v[k2] = nil
            break
          end
        end
      end
    end,
    isClear = function(self)
      local sum = 0
      for k, v in pairs(Driver.objects) do
        for k2, o in pairs(v) do
          if k ~= EntityTypes.player and k ~= EntityTypes.turret then
            sum = sum + 1
          end
        end
      end
      return sum == 0
    end,
    keypressed = function(key, scancode, isrepeat)
      if key == "escape" then
        return love.event.quit()
      elseif key == "p" then
        PAUSED = not PAUSED
      else
        if not (PAUSED or GAME_OVER) then
          for k, v in pairs(Driver.objects[EntityTypes.player]) do
            v:keypressed(key)
          end
        end
      end
    end,
    keyreleased = function(key)
      if not (PAUSED or GAME_OVER) then
        for k, v in pairs(Driver.objects[EntityTypes.player]) do
          v:keyreleased(key)
        end
      end
    end,
    mouspressed = function(x, y, button, isTouch) end,
    mousereleased = function(x, y, button, isTouch) end,
    focus = function(focus) end,
    load = function(arg)
      local player = Player(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, Sprite("test.tga", 16, 16, 0.29, 4))
      player.sprite:setRotationSpeed(-math.pi / 2)
      Driver:addObject(player, EntityTypes.player)
      return Objectives:nextMode()
    end,
    update = function(dt)
      if GAME_OVER then
        Driver.objects = nil
        Renderer.layers = nil
      end
      if PAUSED or GAME_OVER then
        return 
      end
      for k, v in pairs(Driver.objects) do
        for k2, o in pairs(v) do
          o:update(dt)
          if o.health <= 0 or not o.alive then
            Driver:removeObject(o)
          end
        end
      end
      return Objectives:update(dt)
    end,
    draw = function()
      love.graphics.push("all")
      Renderer:drawAlignedMessage(SCORE .. "\t", 20, "right", Renderer.hud_font)
      if not GAME_OVER then
        Renderer:drawAll()
        Objectives:draw()
        if PAUSED then
          Renderer:drawStatusMessage("PAUSED", love.graphics.getHeight() / 2, Renderer.giant_font)
        end
      else
        Renderer:drawStatusMessage("YOU DIED!", love.graphics.getHeight() / 2, Renderer.giant_font)
      end
      love.graphics.pop()
      local before = math.floor(collectgarbage("count"))
      collectgarbage("step")
      local after = math.floor(collectgarbage("count"))
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
