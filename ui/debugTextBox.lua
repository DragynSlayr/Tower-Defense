do
  local _class_0
  local _parent_0 = TextBox
  local _base_0 = {
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
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        ""
      }
      self.max_saved = 10
      self.saved_index = 1
      self.action["return"] = function()
        if love.keyboard.isDown("rshift", "lshift") then
          self.text = self.text .. "\n"
        else
          self.saved[self.saved_index] = self.text
          self.saved_index = self.saved_index + 1
          if self.saved_index > self.max_saved then
            self.saved_index = 1
          end
          local text = self.text
          self.text = ""
          local f = loadstring(text)
          if (pcall(f)) then
            self.status_text = "Command Successful"
          else
            self.status_text = "Invalid Command"
          end
        end
      end
      self.action["up"] = function()
        self.saved_index = self.saved_index - 1
        if self.saved_index < 1 then
          self.saved_index = self.max_saved
        end
        self.text = self.saved[self.saved_index]
      end
      self.action["down"] = function()
        self.saved_index = self.saved_index + 1
        if self.saved_index > self.max_saved then
          self.saved_index = 1
        end
        self.text = self.saved[self.saved_index]
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
