do
  local _class_0
  local _parent_0 = TextBox
  local _base_0 = {
    recoverSaved = function(self)
      self.lines = self.saved[self.saved_index]
      if #self.lines > 0 then
        self.lines_index = #self.lines
      else
        self.lines_index = 1
      end
      if self.lines[self.lines_index] then
        self.char_index = #self.lines[self.lines_index]
      else
        self.char_index = 1
      end
    end,
    draw = function(self)
      _class_0.__parent.__base.draw(self)
      love.graphics.push("all")
      love.graphics.setColor(0, 255, 0, 255)
      love.graphics.setFont(self.font)
      local height = self.font:getHeight()
      local width = self.font:getWidth(self.status_text)
      love.graphics.printf(self.status_text, self.x + self.width - (10 * Scale.width) - width, self.y + self.height - (10 * Scale.height) - height, width, "center")
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, width, height)
      _class_0.__parent.__init(self, x, y, width, height)
      self.status_text = ""
      self.saved = {
        { },
        { },
        { },
        { },
        { },
        { },
        { },
        { },
        { },
        { }
      }
      self.max_saved = 10
      self.saved_index = 1
      self.action["return"] = function()
        if love.keyboard.isDown("rshift", "lshift") then
          self.lines_index = self.lines_index + 1
          table.insert(self.lines, self.lines_index, { })
          self.char_index = 1
        else
          self.saved[self.saved_index] = self.lines
          self.saved_index = self.saved_index + 1
          if self.saved_index > self.max_saved then
            self.saved_index = 1
          end
          local text = self:getText()
          self.lines = { }
          self.lines_index = 1
          self.char_index = 1
          local f = loadstring(text)
          if (pcall(f)) then
            self.status_text = "Command Successful"
          else
            self.status_text = "Invalid Command"
          end
        end
      end
      self.action["pageup"] = function()
        self.saved_index = self.saved_index - 1
        if self.saved_index < 1 then
          self.saved_index = self.max_saved
        end
        return self:recoverSaved()
      end
      self.action["pagedown"] = function()
        self.saved_index = self.saved_index + 1
        if self.saved_index > self.max_saved then
          self.saved_index = 1
        end
        return self:recoverSaved()
      end
    end,
    __base = _base_0,
    __name = "DebugTextBox",
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
  DebugTextBox = _class_0
end
