do
  local _parent_0 = Button
  local _base_0 = {
    onSelect = function(self, x, y)
      if self.open then
        local option = math.floor((((y - self.y) / self.option_height) + 1))
        self.text = self.options[option]
      end
      self.open = not self.open
    end,
    isHovering = function(self, x, y)
      local height = self.option_height
      if self.open then
        height = height * #self.options
      end
      local xOn = self.x <= x and self.x + self.width >= x
      local yOn = self.y <= y and self.y + height >= y
      return xOn and yOn
    end,
    mousereleased = function(self, x, y, button, isTouch)
      if self.active then
        if button == 1 then
          local selected = self:isHovering(x, y)
          if selected and self.selected then
            self:onSelect(x, y)
            self.elapsed = 0
          else
            self.open = false
          end
          self.selected = false
        end
      end
    end,
    draw = function(self)
      love.graphics.push("all")
      if self.active then
        if self.open then
          for k, v in pairs(self.options) do
            local y = self.y + ((k - 1) * self.option_height)
            if v == self.text then
              self.idle_sprite:draw(self.x + (self.width / 2), y + (self.height / 2))
            else
              self.hover_sprite:draw(self.x + (self.width / 2), y + (self.height / 2))
            end
          end
        else
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
        end
      else
        love.graphics.setColor(127, 127, 127, 255)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
      end
      love.graphics.setFont(self.font)
      love.graphics.setColor(0, 0, 0)
      local height = self.font:getHeight()
      if self.open then
        for k, v in pairs(self.options) do
          love.graphics.printf(v, self.x, self.y + ((self.height - height) / 2) + ((k - 1) * self.option_height), self.width, "center")
        end
      else
        love.graphics.printf(self.text, self.x, self.y + ((self.height - height) / 2), self.width, "center")
      end
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, x, y, width, height, options, font)
      _parent_0.__init(self, x, y, width, height, options[1], nil, font)
      self.options = options
      self.open = false
      self.option_height = self.height
    end,
    __base = _base_0,
    __name = "ComboBox",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
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
  ComboBox = _class_0
end
