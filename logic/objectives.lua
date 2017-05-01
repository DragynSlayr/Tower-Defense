do
  local _class_0
  local _base_0 = {
    nextMode = function(self)
      local num = math.random(self.num_modes)
      local _exp_0 = num
      if 1 == _exp_0 then
        self.mode = EliminationMode(15)
      else
        self.mode = nil
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
        Renderer:drawStatusMessage("Objective Complete!", love.graphics.getHeight() / 2)
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
