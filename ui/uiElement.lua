do
  local _class_0
  local _base_0 = {
    keypressed = function(self, key, scancode, isrepeat) end,
    keyreleased = function(self, key) end,
    mousepressed = function(self, x, y, button, isTouch) end,
    mousereleased = function(self, x, y, button, isTouch) end,
    focus = function(self, focus) end,
    update = function(self, dt) end,
    draw = function(self)
      love.graphics.push("all")
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.setFont(self.font)
      local height = self.font:getHeight()
      local width = self.font:getWidth(self.text)
      love.graphics.printf(self.text, self.x - (width / 2), self.y - (height / 2), width, "center")
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, text, font)
      if font == nil then
        font = Renderer.status_font
      end
      self.x = x
      self.y = y
      self.text = text
      self.font = font
    end,
    __base = _base_0,
    __name = "UIElement"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  UIElement = _class_0
end
