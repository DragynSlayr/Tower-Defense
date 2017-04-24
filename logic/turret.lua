do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt) end,
    draw = function(self)
      if DEBUGGING then
        love.graphics.push("all")
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.circle("fill", self.position.x, self.position.y, self.range, 25)
        love.graphics.pop()
      end
      return _class_0.__parent.__base.draw(self)
    end,
    drawFaded = function(self)
      love.graphics.push("all")
      local r, g, b, a = love.graphics.getColor()
      love.graphics.setColor(r, g, b, 50)
      love.graphics.circle("fill", self.position.x, self.position.y, self.range, 25)
      self.sprite:draw(self.position.x, self.position.y)
      return love.graphics.pop()
    end,
    isOnScreen = function(self)
      local circle = self:getHitBox()
      local x, y = circle.center:getComponents()
      local radius = self.range
      local xOn = x - radius >= 0 and x + radius <= love.graphics.getWidth()
      local yOn = y - radius >= 0 and y + radius <= love.graphics.getHeight()
      return xOn and yOn
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, range, sprite)
      _class_0.__parent.__init(self, x, y, sprite, 0, 0)
      self.range = self.sprite:getBounds().radius + range
    end,
    __base = _base_0,
    __name = "Turret",
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
  Turret = _class_0
end
