do
  local _class_0
  local _parent_0 = UIElement
  local _base_0 = {
    textinput = function(self, text)
      if text ~= '`' then
        self.text = self.text .. text
      end
    end,
    keypressed = function(self, key, scancode, isrepeat)
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
    end,
    draw = function(self)
      love.graphics.push("all")
      love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.color[4])
      love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.setFont(self.font)
      local height = self.font:getHeight()
      local width = self.font:getWidth(self.text)
      love.graphics.printf(self.text, self.x + (10 * Scale.width), self.y + (height / 2), self.width, "left")
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
        127,
        127,
        127,
        200
      }
      self.font = love.graphics.newFont(20)
      self.action = { }
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
