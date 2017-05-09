do
  local _class_0
  local _base_0 = {
    nextMode = function(self)
      self.counter = self.counter + 1
      if self.counter <= #self.modes then
        self.mode = self.modes[self.counter]
        return self.mode:start()
      else
        self.counter = 0
        MathHelper:shuffle(self.modes)
        return self:nextMode()
      end
    end,
    entityKilled = function(self, entity)
      return self.mode:entityKilled(entity)
    end,
    update = function(self, dt)
      if not self.mode.complete then
        return self.mode:update(dt)
      else
        self.elapsed = self.elapsed + dt
        if self.elapsed >= self.delay then
          self.elapsed = 0
          return self:nextMode()
        end
      end
    end,
    draw = function(self)
      if not self.mode.complete then
        return self.mode:draw()
      else
        love.graphics.push("all")
        Renderer:drawStatusMessage("Objective Complete!", love.graphics.getHeight() / 2, Renderer.title_font)
        return love.graphics.pop()
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.num_modes = 1
      self.mode = nil
      self.elapsed = 0
      self.delay = 10
      self.modes = {
        EliminationMode(),
        EliminationMode(),
        EliminationMode()
      }
      self.counter = 0
    end,
    __base = _base_0,
    __name = "Objectives"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Objectives = _class_0
end
