do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    __tostring = function(self)
      return "Enemy"
    end,
    onCollide = function(self, object)
      if not self.alive then
        return 
      end
      _class_0.__parent.__base.onCollide(self, object)
      if object.slowing then
        self.speed_multiplier = 0
      end
    end,
    update = function(self, dt, search)
      if search == nil then
        search = false
      end
      if not self.alive then
        return 
      end
      self:findNearestTarget(search)
      if not self.target then
        return 
      end
      local dist = self.position:getDistanceBetween(self.target.position)
      if dist < love.graphics.getWidth() / 4 then
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
          enemy.radius = enemy.radius + self.attack_range
          if target:contains(enemy) then
            self.target:onCollide(self)
            self.speed_multiplier = 0
            if self.target.health <= 0 then
              return self:findNearestTarget()
            end
          end
        end
      else
        self.speed = Vector(self.target.position.x - self.position.x, self.target.position.y - self.position.y)
        local length = self.speed:getLength()
        local x = self.speed.x / length
        local y = self.speed.y / length
        local diff = math.abs(x - y)
        if diff <= 1.3 and diff >= 0.05 then
          local copy = self.speed:getAbsolute()
          if copy.x > copy.y then
            self.speed = Vector(self.speed.x, 0)
          elseif copy.x < copy.y then
            self.speed = Vector(0, self.speed.y)
          end
        end
        self.speed:toUnitVector()
        self.speed = self.speed:multiply(MathHelper:clamp(self.speed_multiplier, 0, self.max_speed))
        self.speed_multiplier = self.speed_multiplier + 1
        _class_0.__parent.__base.update(self, dt)
        local vec = Vector(0, 0)
        self.sprite.rotation = self.speed:getAngleBetween(vec)
      end
    end,
    draw = function(self)
      if not self.alive then
        return 
      end
      if DEBUGGING then
        love.graphics.push("all")
        love.graphics.setColor(255, 0, 255, 127)
        local enemy = self:getHitBox()
        love.graphics.circle("fill", self.position.x, self.position.y, self.attack_range + enemy.radius, 360)
        love.graphics.pop()
      end
      return _class_0.__parent.__base.draw(self)
    end,
    findNearestTarget = function(self, all)
      if all == nil then
        all = false
      end
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
      if Driver.objects[EntityTypes.goal] then
        for k, v in pairs(Driver.objects[EntityTypes.goal]) do
          if v.goal_type == GoalTypes.defend then
            local goal = v:getHitBox()
            local enemy = self:getHitBox()
            local dist = Vector(enemy.center.x - goal.center.x, enemy.center.y - goal.center.y)
            if dist:getLength() < closest_distance then
              closest_distance = dist:getLength()
              closest = v
            end
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
      if target == nil then
        target = nil
      end
      _class_0.__parent.__init(self, x, y, sprite)
      self.target = target
      local bounds = self.sprite:getBounds(0, 0)
      self.attack_range = bounds.radius * 2
      self.delay = 1
      self.id = EntityTypes.enemy
      self.max_speed = 150
      self.speed_multiplier = self.max_speed
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
