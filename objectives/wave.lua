do
  local _class_0
  local _base_0 = {
    start = function(self) end,
    entityKilled = function(self, entity) end,
    update = function(self, dt)
      if self.waiting then
        self.elapsed = self.elapsed + dt
        if self.elapsed >= self.delay then
          self.elapsed = 0
          self.waiting = false
          return self:start()
        end
      end
    end,
    draw = function(self)
      if self.waiting then
        love.graphics.push("all")
        local message = (self.delay - math.floor(self.elapsed))
        Renderer:drawStatusMessage(message, love.graphics.getHeight() / 2, Renderer.giant_font)
        Renderer:drawAlignedMessage("Next wave in: " .. message .. "\t", 50, "right", Renderer.hud_font)
        return love.graphics.pop()
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.elapsed = 0
      self.delay = 5
      self.waiting = true
      self.complete = false
      self.parent = parent
    end,
    __base = _base_0,
    __name = "Wave"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Wave = _class_0
end
