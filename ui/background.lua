do
  local _class_0
  local _parent_0 = UIElement
  local _base_0 = {
    setSprite = function(self, sprite)
      self.sprite = sprite
    end,
    draw = function(self)
      love.graphics.push("all")
      if self.sprite then
        self.sprite:draw(Screen_Size.half_width, Screen_Size.half_height)
      else
        love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.color[4])
        love.graphics.rectangle("fill", 0, 0, Screen_Size.width, Screen_Size.height)
      end
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, color)
      _class_0.__parent.__init(self, 0, 0, "")
      self.color = color
    end,
    __base = _base_0,
    __name = "Background",
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
  Background = _class_0
end
