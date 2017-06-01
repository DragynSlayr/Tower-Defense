do
  local _class_0
  local _parent_0 = UIElement
  local _base_0 = {
    setColor = function(self, idle, hover)
      self.idle_color = idle
      self.hover_color = hover
    end,
    setSprite = function(self, idle, hover)
      self.idle_sprite = idle
      self.hover_sprite = hover
      self.sprited = true
    end,
    autoResize = function(self, max_width, max_height, x_border, y_border)
      if x_border == nil then
        x_border = 20
      end
      if y_border == nil then
        y_border = x_border
      end
      local width = self.font:getWidth(self.text)
      self.width = math.min(width + x_border, max_width)
      local height = self.font:getHeight()
      self.height = math.min(height + y_border, max_height)
    end,
    isHovering = function(self, x, y)
      local xOn = self.x <= x and self.x + self.width >= x
      local yOn = self.y <= y and self.y + self.height >= y
      return xOn and yOn
    end,
    mousepressed = function(self, x, y, button, isTouch)
      if button == 1 then
        self.selected = self:isHovering(x, y)
      end
    end,
    mousereleased = function(self, x, y, button, isTouch)
      if button == 1 then
        local selected = self:isHovering(x, y)
        if selected and self.selected then
          self:action()
          self.elapsed = 0
        end
        self.selected = false
      end
    end,
    update = function(self, dt)
      if self.sprited then
        self.idle_sprite:update(dt)
        return self.hover_sprite:update(dt)
      end
    end,
    draw = function(self)
      love.graphics.push("all")
      if self.sprited then
        if self.selected then
          self.hover_sprite:draw(self.x + (self.width / 2), self.y + (self.height / 2))
        else
          self.idle_sprite:draw(self.x + (self.width / 2), self.y + (self.height / 2))
        end
      else
        if self.selected then
          love.graphics.setColor(self.hover_color:get())
        else
          love.graphics.setColor(self.idle_color:get())
        end
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
      end
      love.graphics.setFont(self.font)
      love.graphics.setColor(0, 0, 0)
      local height = self.font:getHeight()
      love.graphics.printf(self.text, self.x, self.y + ((self.height - height) / 2), self.width, "center")
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, width, height, text, action, font)
      if font == nil then
        font = Renderer.hud_font
      end
      _class_0.__parent.__init(self, x, y, text, font)
      self.width = width * Scale.width
      self.height = height * Scale.height
      self.action = action
      self.x = self.x - (self.width / 2)
      self.y = self.y - (self.height / 2)
      self.idle_color = Color(175, 175, 175)
      self.hover_color = Color(100, 100, 100)
      self.selected = false
    end,
    __base = _base_0,
    __name = "Button",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Button = _class_0
end
