do
  local _class_0
  local _parent_0 = Tooltip
  local _base_0 = {
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      self.elapsed = self.elapsed + (dt * self.speed)
      local num = ((math.sin(self.elapsed)) + 1) / 2
      self.alpha = math.ceil(num * 255)
    end,
    draw = function(self)
      if self.enabled and not self.blocked then
        love.graphics.push("all")
        local x = self.x - (self.width / 2)
        local y = self.y - (self.height / 2)
        love.graphics.setColor(self.box_color[1], self.box_color[2], self.box_color[3], self.alpha)
        love.graphics.rectangle("fill", x, y, self.width, self.height)
        love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.color[4])
        love.graphics.setFont(self.font)
        love.graphics.printf(self.text, x, self.y - (self.font:getHeight() / 2), self.width, self.alignment)
        return love.graphics.pop()
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, width, height, textFunc, alignment)
      if alignment == nil then
        alignment = "center"
      end
      _class_0.__parent.__init(self, x, y, textFunc, nil, alignment)
      self.width = width
      self.height = height
      self.font = Renderer:newFont(self.height)
      self.elapsed = 0
      self.box_color = {
        255,
        215,
        0
      }
      self.alpha = 0
      self.speed = 3
      self.blocked = false
    end,
    __base = _base_0,
    __name = "TooltipBox",
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
  TooltipBox = _class_0
end
