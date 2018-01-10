do
  local _class_0
  local _parent_0 = Text
  local _base_0 = {
    update = function(self, dt)
      self.text = self:textFunc()
    end,
    draw = function(self)
      if self.enabled then
        love.graphics.push("all")
        love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.color[4])
        love.graphics.setFont(self.font)
        local height = self.font:getHeight()
        local width = self.font:getWidth(self.text)
        love.graphics.printf(self.text, self.x, self.y - (height / 2), width, self.alignment)
        return love.graphics.pop()
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, textFunc, font, alignment)
      if alignment == nil then
        alignment = "left"
      end
      self.textFunc = textFunc
      _class_0.__parent.__init(self, x, y, self:textFunc(), font)
      self.enabled = false
      self.alignment = alignment
    end,
    __base = _base_0,
    __name = "Tooltip",
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
  Tooltip = _class_0
end
