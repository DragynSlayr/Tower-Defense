do
  local _parent_0 = Button
  local _base_0 = {
    mousereleased = function(self, x, y, button, isTouch)
      if self.active then
        if button == 1 then
          local selected = self:isHovering(x, y)
          if selected and self.selected then
            self.checked = not self.checked
            self.elapsed = 0
          end
          self.selected = false
        end
      end
    end,
    update = function(self, dt)
      self.idle_sprite:update(dt)
      self.hover_sprite:update(dt)
      return self.checked_sprite:update(dt)
    end,
    draw = function(self)
      love.graphics.push("all")
      if self.active then
        local shift_x = self.x + (self.width / 2)
        local shift_y = self.y + (self.height / 2)
        if self.selected or self.checked then
          self.hover_sprite:draw(shift_x, shift_y)
        else
          self.idle_sprite:draw(shift_x, shift_y)
        end
        if self.checked then
          self.checked_sprite:draw(shift_x, shift_y)
        end
      else
        love.graphics.setColor(127, 127, 127, 255)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
      end
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, x, y, size, action, font)
      _parent_0.__init(self, x, y, size, size, "", action, font)
      self.checked = false
      self.idle_sprite = Sprite("ui/checkbox/idle.tga", 32, 32, 1, 1)
      self.hover_sprite = Sprite("ui/checkbox/hover.tga", 32, 32, 1, 1)
      self.checked_sprite = Sprite("ui/checkbox/checked.tga", 28, 28, 1, 0.9)
    end,
    __base = _base_0,
    __name = "CheckBox",
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
  CheckBox = _class_0
end
