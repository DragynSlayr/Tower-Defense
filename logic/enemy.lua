do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      if not self.alive then
        return 
      end
      self:findNearestTarget()
      if not self.target then
        return 
      end
      self.speed = Vector(self.target.position.x - self.position.x, self.target.position.y - self.position.y)
      self.speed:toUnitVector()
      self.speed = self.speed:multiply(MathHelper:clamp(self.speed_multiplier, 0, self.max_speed))
      self.speed_multiplier = self.speed_multiplier + 1
      _class_0.__parent.__base.update(self, dt)
      local vec = Vector(0, 0)
      self.sprite.rotation = self.speed:getAngleBetween(vec)
      if self.elapsed >= self.delay then
        self.elapsed = 0
        local target = self.target:getHitBox()
        local enemy = self:getHitBox()
        target.radius = target.radius + (enemy.radius + self.attack_range)
        if target:contains(enemy.center) then
          self.target:onCollide(self)
          self.speed_multiplier = 0
          if self.target.health <= 0 then
            return self:findNearestTarget()
          end
        end
      end
    end,
    draw = function(self)
      if not self.alive then
        return 
      end
      if DEBUGGING then
        love.graphics.push("all")
        love.graphics.setColor(255, 0, 255, 255)
        local enemy = self:getHitBox()
        love.graphics.circle("fill", self.position.x, self.position.y, self.attack_range + enemy.radius, 25)
        love.graphics.pop()
      end
      return _class_0.__parent.__base.draw(self)
    end,
    findNearestTarget = function(self)
      local closest = nil
      local closest_distance = math.max(love.graphics.getWidth() * 2, love.graphics.getHeight() * 2)
      if Driver.objects[EntityTypes.player] then
        for k, v in pairs(Driver.objects[EntityTypes.player]) do
          local player = v:getHitBox()
          local enemy = self:getHitBox()
          local dist = Vector(enemy.center.x - player.center.x, enemy.center.y - player.center.y)
          if dist:getLength() < closest_distance then
            closest_distance = dist:getLength()
            closest = v
          end
        end
      end
      if Driver.objects[EntityTypes.turret] then
        for k, v in pairs(Driver.objects[EntityTypes.turret]) do
          local turret = v:getHitBox()
          local enemy = self:getHitBox()
          local dist = Vector(enemy.center.x - turret.center.x, enemy.center.y - turret.center.y)
          if dist:getLength() < closest_distance then
            closest_distance = dist:getLength()
            closest = v
          end
        end
      end
      self.target = closest
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, sprite, target)
      _class_0.__parent.__init(self, x, y, sprite)
      self.target = target
      self.attack_range = 30
      self.delay = 1
      self.max_speed = 150
      self.speed_multiplier = 150
      self.id = EntityTypes.enemy
    end,
    __base = _base_0,
    __name = "Enemy",
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
  Enemy = _class_0
end
