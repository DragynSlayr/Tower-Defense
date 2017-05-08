do
  local _class_0
  local _base_0 = {
    start = function(self) end,
    entityKilled = function(self, entity) end,
    update = function(self, dt)
      if self.waiting then
        self.elapsed = self.elapsed + dt
        if self.elapsed >= self.delay then
          self.waiting = false
          return self:start()
        end
      end
    end,
    draw = function(self)
      love.graphics.push("all")
      love.graphics.setColor(0, 0, 0, 255)
      Renderer:drawAlignedMessage(self.message, 20, "left", Renderer.hud_font)
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.elapsed = 0
      self.delay = 5
      self.waiting = true
      self.complete = false
      self.message = "DEFAULT MODE"
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
