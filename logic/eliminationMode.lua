do
  local _class_0
  local _base_0 = {
    entityKilled = function(self, entity)
      return self.wave:entityKilled(entity)
    end,
    nextWave = function(self)
      local num = (((self.counter - 1) * 3) + self.level) * 3
      self.wave = EliminationWave(self, num + 5, num / 3)
    end,
    start = function(self)
      self.complete = false
      self.level = 1
      self:nextWave()
      self.started = true
    end,
    update = function(self, dt)
      if not self.complete then
        if not self.started then
          self:start()
        end
        if not self.wave.complete then
          self.wave:update(dt)
          self.message2 = "Level " .. self.counter .. "\tWave " .. self.level .. "/3"
        else
          self.level = self.level + 1
          if (self.level - 1) % 3 == 0 then
            self.counter = self.counter + 1
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
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.level = 1
      self.counter = 1
      self.complete = false
      self.wave = nil
      self.message1 = ""
      self.message2 = ""
      self.started = false
    end,
    __base = _base_0,
    __name = "EliminationMode"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  EliminationMode = _class_0
end
