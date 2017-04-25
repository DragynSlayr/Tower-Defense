do
  local _class_0
  local _base_0 = {
    getHitBox = function(self)
      return self.sprite:getBounds(self.position.x, self.position.y)
    end,
    onCollide = function(self, object)
      print(self.__name .. " hit " .. object.__name)
      self.health = self.health - object.damage
    end,
    update = function(self, dt)
      self.sprite:update(dt)
      self.elapsed = self.elapsed + dt
      if self.ai then
        self:ai(dt)
      else
        self.position:add(self.speed:multiply(dt))
      end
      local radius = self:getHitBox().radius
      self.position.x = MathHelper:clamp(self.position.x, radius, love.graphics.getWidth() - radius)
      self.position.y = MathHelper:clamp(self.position.y, radius, love.graphics.getHeight() - radius)
    end,
    draw = function(self)
      self.sprite:draw(self.position.x, self.position.y)
      love.graphics.push("all")
      love.graphics.setColor(0, 0, 0, 255)
      local radius = self:getHitBox().radius
      love.graphics.rectangle("fill", (self.position.x - radius) - 3, (self.position.y + radius) + 3, (radius * 2) + 6, 16)
      love.graphics.setColor(0, 255, 0, 255)
      love.graphics.rectangle("fill", self.position.x - radius, (self.position.y + radius) + 6, radius * 2, 10)
      return love.graphics.pop()
    end,
    isOnScreen = function(self)
      local circle = self:getHitBox()
      local x, y = circle.center:getComponents()
      local radius = circle.radius
      local xOn = x - radius >= 0 and x + radius <= love.graphics.getWidth()
      local yOn = y - radius >= 0 and y + radius <= love.graphics.getHeight()
      return xOn and yOn
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, sprite, x_speed, y_speed, ai)
      if x_speed == nil then
        x_speed = 0
      end
      if y_speed == nil then
        y_speed = 0
      end
      if ai == nil then
        ai = nil
      end
      self.position = Vector(x, y)
      self.speed = Vector(x_speed, y_speed)
      self.sprite = sprite
      self.ai = ai
      self.elapsed = 0
      self.health = 5
      self.damage = 1
    end,
    __base = _base_0,
    __name = "GameObject"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  GameObject = _class_0
end
