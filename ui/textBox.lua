do
  local _class_0
  local _parent_0 = UIElement
  local _base_0 = {
    getText = function(self)
      local s = ""
      for k, v in pairs(self.lines) do
        for k2, v2 in pairs(v) do
          s = s .. v2
        end
        if k ~= #self.lines then
          s = s .. "\n"
        end
      end
      return s
    end,
    getLine = function(self, idx, idx2)
      if idx2 == nil then
        idx2 = #self.lines[idx]
      end
      local s = ""
      for k, v in pairs(self.lines[idx]) do
        if k < idx2 then
          s = s .. v
        end
      end
      return s
    end,
    textinput = function(self, text)
      if self.active then
        if text ~= '`' then
          if not self.lines[self.lines_index] then
            self.lines[self.lines_index] = { }
          end
          self.char_index = self.char_index + 1
          return table.insert(self.lines[self.lines_index], self.char_index, text)
        end
      end
    end,
    keypressed = function(self, key, scancode, isrepeat)
      if self.active then
        if key == "backspace" then
          if #self.lines[self.lines_index] ~= 0 then
            table.remove(self.lines[self.lines_index], self.char_index)
            self.char_index = self.char_index - 1
          else
            if self.lines_index > 1 then
              self.lines_index = self.lines_index - 1
              self.char_index = #self.lines[self.lines_index]
            end
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
      local height = self.font:getHeight()
      local width = 0
      if self.lines[self.lines_index] then
        width = self.font:getWidth(self:getLine(self.lines_index, (self.char_index + 1)))
      end
      self.cursor.position = Point(self.x + (10 * Scale.width) + width, self.y + (height / 2) + ((self.lines_index - 1) * height))
    end,
    draw = function(self)
      love.graphics.push("all")
      love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.color[4])
      love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
      local text = self:getText()
      love.graphics.setColor(0, 255, 0, 255)
      love.graphics.setFont(self.font)
      local height = self.font:getHeight()
      local width = self.font:getWidth(text)
      love.graphics.printf(text, self.x + (10 * Scale.width), self.y + (height / 2), self.width, "left")
      if self.active then
        love.graphics.setColor(0, 255, 0, self.cursor.alpha)
        width = 0
        if self.lines[self.lines_index] then
          width = self.font:getWidth(self:getLine(self.lines_index, (self.char_index + 1)))
        end
        love.graphics.rectangle("fill", self.x + (10 * Scale.width) + width, self.y + (height / 2) + ((self.lines_index - 1) * height), 10 * Scale.width, height)
        self.cursor.position = Point(self.x + (10 * Scale.width) + width, self.y + (height / 2) + ((self.lines_index - 1) * height))
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
      self.cursor.position = Point(0, 0)
      self.active = true
      self.selected = false
      self.lines = { }
      self.lines_index = 1
      self.char_index = 1
      self.action = { }
      self.action["tab"] = function()
        if not self.lines[self.lines_index] then
          self.lines[self.lines_index] = { }
        end
        for i = 1, 4 do
          table.insert(self.lines[self.lines_index], self.char_index, " ")
          self.char_index = self.char_index + 1
        end
      end
      self.action["return"] = function()
        self.lines_index = self.lines_index + 1
        table.insert(self.lines, self.lines_index, { })
        self.char_index = 1
      end
      self.action["up"] = function()
        if self.lines_index > 1 then
          self.lines_index = self.lines_index - 1
          self.char_index = #self.lines[self.lines_index]
        end
      end
      self.action["down"] = function()
        if self.lines_index < #self.lines then
          self.lines_index = self.lines_index + 1
          self.char_index = #self.lines[self.lines_index]
        end
      end
      self.action["left"] = function()
        if self.char_index > 1 then
          self.char_index = self.char_index - 1
        end
      end
      self.action["right"] = function()
        if self.lines[self.lines_index] then
          if self.char_index < #self.lines[self.lines_index] then
            self.char_index = self.char_index + 1
          end
        end
      end
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
