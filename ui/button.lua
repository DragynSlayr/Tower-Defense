do
  local _class_0
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
    draw = function(self)
      love.graphics.push("all")
      if self.sprited then
        if self.selected then
          self.hover_sprite:draw(self.x, self.y)
        else
          self.idle_sprite:draw(self.x, self.y)
        end
      else
        if self.selected then
          love.graphics.setColor(self.hover_color[1], self.hover_color[2], self.hover_color[3], self.hover_color[4])
        else
          love.graphics.setColor(self.idle_color[1], self.idle_color[2], self.idle_color[3], self.idle_color[4])
        end
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
      end
      love.graphics.setColor(0, 0, 0)
      love.graphics.printf(self.text, self.x, self.y + ((self.height - love.graphics.getFont:getHeight()) / 2), self.width, "center")
      return love.graphics.pop()
    end,
    update = function(self, dt)
      local x, y = love.mouse.getPosition()
      self.selected = self:isHovering(x, y)
      if self.selected and love.mouse.isDown(1) then
        self:action()
      end
      if self.sprited then
        self.idle_sprite:update(dt)
        return self.hover_sprite:update(dt)
      end
    end,
    isHovering = function(self, x, y)
      local xOn = self.x <= x and self.x + self.width >= x
      local yOn = self.y <= y and self.y + self.height >= y
      return xOn and yOn
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, width, height, text, action)
      self.x = x
      self.y = y
      self.width = width
      self.height = height
      self.text = text
      self.action = action
      self.idle_color = {
        175,
        175,
        175
      }
      self.hover_color = {
        100,
        100,
        100
      }
      self.selected = false
    end,
    __base = _base_0,
    __name = "Button"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Button = _class_0
end
