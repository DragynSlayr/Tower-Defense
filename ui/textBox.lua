do
  local _class_0
  local _parent_0 = UIElement
  local _base_0 = {
    textinput = function(self, text)
      if self.active then
        if text ~= '`' then
          self.text = self.text .. text
        end
      end
    end,
    keypressed = function(self, key, scancode, isrepeat)
      if self.active then
        if key == "backspace" then
          local length = string.len(self.text)
          if length > 0 then
            self.text = string.sub(self.text, 1, length - 1)
          else
            self.text = ""
          end
        else
          if self.action[key] then
            return self.action[key]()
          end
        end
      end
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
          self.active = true
        else
          self.active = false
        end
        self.selected = false
      end
    end,
    update = function(self, dt)
      self.elapsed = self.elapsed + dt
      if self.cursor.is_on then
        if self.elapsed >= self.cursor.on_time then
          self.elapsed = 0
          self.cursor.alpha = 0
          self.cursor.is_on = false
        end
      else
        if self.elapsed >= self.cursor.off_time then
          self.elapsed = 0
          self.cursor.alpha = 255
          self.cursor.is_on = true
        end
      end
    end,
    draw = function(self)
      love.graphics.push("all")
      love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.color[4])
      love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
      love.graphics.setColor(0, 255, 0, 255)
      love.graphics.setFont(self.font)
      local height = self.font:getHeight()
      local width = self.font:getWidth(self.text)
      love.graphics.printf(self.text, self.x + (10 * Scale.width), self.y + (height / 2), self.width, "left")
      if self.active then
        love.graphics.setColor(0, 255, 0, self.cursor.alpha)
        local num_lines = 0
        local last_n = 1
        for i = 1, #self.text do
          if (string.sub(self.text, i, i)) == "\n" then
            num_lines = num_lines + 1
            last_n = i
          end
        end
        width = self.font:getWidth(string.sub(self.text, last_n, #self.text))
        love.graphics.rectangle("fill", self.x + (10 * Scale.width) + width, self.y + (height / 2) + (num_lines * height), 10 * Scale.width, height)
      end
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, width, height)
      _class_0.__parent.__init(self, x, y)
      self.width = width
      self.height = height
      self.color = {
        0,
        0,
        0,
        127
      }
      self.font = love.graphics.newFont(20)
      self.elapsed = 0
      self.cursor = { }
      self.cursor.alpha = 255
      self.cursor.on_time = 0.33
      self.cursor.off_time = 0.33
      self.cursor.is_on = true
      self.action = { }
      self.action["tab"] = function()
        self.text = self.text .. "    "
      end
      self.active = false
      self.selected = false
    end,
    __base = _base_0,
    __name = "TextBox",
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
  TextBox = _class_0
end
