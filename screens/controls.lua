do
  local _class_0
  local _parent_0 = Screen
  local _base_0 = {
    keyreleased = function(self, key)
      if self.selected ~= "" then
        if key ~= "backspace" then
          self.keys[self.key_names[self.selected]] = key
          self.button.text = key
          writeKey(self.key_names[self.selected], key)
        end
        self.button.selected = false
        self.button = nil
        self.selected_text = ""
      end
    end,
    draw = function(self)
      if self.selected ~= "" and self.button then
        self.button.selected = true
        love.graphics.push("all")
        love.graphics.setFont(Renderer.hud_font)
        love.graphics.setColor(0, 0, 0, 255)
        local text = "Press a button for " .. self.selected_text .. " or 'Backspace' to cancel"
        love.graphics.printf(text, 0, Screen_Size.height * 0.835, Screen_Size.width, "center")
        return love.graphics.pop()
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      local contents, _ = love.filesystem.read("SETTINGS")
      local lines = split(contents, "\n")
      local idx = -1
      for k, v in pairs(lines) do
        if (string.sub(v, 1, 7)) == "MOVE_UP" then
          idx = k
          break
        end
      end
      self.keys = { }
      self.key_names = { }
      for i = idx, #lines do
        local line = split(lines[i], " ")
        self.keys[line[1]] = line[2]
        if #line[1] > 0 then
          table.insert(self.key_names, line[1])
        end
      end
      self.selected = ""
      self.button = nil
      self.selected_text = ""
    end,
    __base = _base_0,
    __name = "ControlsHandler",
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
  ControlsHandler = _class_0
end
