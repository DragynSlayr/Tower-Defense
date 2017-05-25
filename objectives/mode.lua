do
  local _class_0
  local _base_0 = {
    entityKilled = function(self, entity)
      return self.wave:entityKilled(entity)
    end,
    nextWave = function(self)
      self.parent.difficulty = self.parent.difficulty + 1
    end,
    start = function(self)
      self.complete = false
      self.wave_count = 1
      self:nextWave()
      self.started = true
    end,
    finish = function(self)
      if Driver.objects[EntityTypes.turret] then
        for k, t in pairs(Driver.objects[EntityTypes.turret]) do
          Driver:removeObject(t, false)
        end
      end
      if Driver.objects[EntityTypes.player] then
        for k, p in pairs(Driver.objects[EntityTypes.player]) do
          p.num_turrets = 0
          p.can_place = true
        end
      end
      if Driver.objects[EntityTypes.bullet] then
        for k, b in pairs(Driver.objects[EntityTypes.bullet]) do
          Driver:removeObject(b, false)
        end
      end
    end,
    update = function(self, dt)
      if not self.complete then
        if not self.started then
          self:start()
        end
        if not self.wave.complete then
          self.wave:update(dt)
          local level = self.parent:getLevel() + 1
          self.message2 = "Level " .. level .. "\tWave " .. self.wave_count .. "/3"
        else
          self.wave_count = self.wave_count + 1
          if (self.wave_count - 1) % 3 == 0 then
            self.level_count = self.level_count + 1
            self.complete = true
            self.started = false
          else
            return self:nextWave()
          end
        end
      end
    end,
    draw = function(self)
      self.wave:draw()
      love.graphics.push("all")
      love.graphics.setColor(0, 0, 0, 255)
      Renderer:drawAlignedMessage(self.message1, 20, "left", Renderer.hud_font)
      Renderer:drawAlignedMessage(self.message2, 20, "center", Renderer.hud_font)
      Renderer:drawAlignedMessage(self.objective_text, 50, "center", Renderer.hud_font)
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.level_count = 1
      self.wave_count = 1
      self.complete = false
      self.wave = nil
      self.message1 = ""
      self.message2 = ""
      self.objective_text = ""
      self.started = false
    end,
    __base = _base_0,
    __name = "Mode"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Mode = _class_0
end
