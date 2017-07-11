do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      if not self.alive then
        return 
      end
      if not self.target then
        self:kill()
      end
      if self.trail then
        self.trail:update(dt)
      end
      self.sprite:update(dt)
      self.speed = Vector(self.target.position.x - self.position.x, self.target.position.y - self.position.y)
      self.speed:toUnitVector()
      self.speed = self.speed:multiply(self.speed_multiplier)
      self.position:add(self.speed:multiply(dt))
      local vec = Vector(0, 0)
      self.sprite.rotation = self.speed:getAngleBetween(vec)
      local target = self.target:getHitBox()
      local bullet = self:getHitBox()
      bullet.radius = bullet.radius + self.attack_range
      if target:contains(bullet) then
        self.target:onCollide(self)
        return self:kill()
      end
    end,
    draw = function(self)
      if self.speed:getLength() > 0 then
        if self.target and self.target.health > 0 and self.alive then
          if DEBUGGING then
            love.graphics.push("all")
            love.graphics.setColor(255, 0, 255, 127)
            local enemy = self:getHitBox()
            love.graphics.circle("fill", self.position.x, self.position.y, self.attack_range + enemy.radius, 360)
            love.graphics.pop()
          end
          return _class_0.__parent.__base.draw(self)
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, target, sprite)
      _class_0.__parent.__init(self, x, y, sprite)
      self.target = target
      self.attack_range = 15 * Scale.diag
      self.damage = 1 / 10
      self.id = EntityTypes.bullet
      self.draw_health = false
      self.solid = false
      self.speed_multiplier = 1000
      local sprite_copy = sprite:getCopy()
      self.trail = nil
    end,
    __base = _base_0,
    __name = "HomingProjectile",
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
  HomingProjectile = _class_0
end
