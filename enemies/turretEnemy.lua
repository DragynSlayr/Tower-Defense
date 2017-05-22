do
  local _class_0
  local _parent_0 = Enemy
  local _base_0 = {
    __tostring = function(self)
      return "T: " .. self.enemyType .. "\tH: " .. self.max_health .. "\tD: " .. self.damage .. "\tS: " .. self.max_speed
    end,
    update = function(self, dt)
      if not self.alive then
        return 
      end
      if Driver.objects[EntityTypes.turret] then
        if #Driver.objects[EntityTypes.turret] ~= 0 then
          return _class_0.__parent.__base.update(self, dt, false)
        else
          return _class_0.__parent.__base.update(self, dt, true)
        end
      else
        return _class_0.__parent.__base.update(self, dt, true)
      end
    end,
    findNearestTarget = function(self, all)
      if all == nil then
        all = false
      end
      local closest = nil
      local closest_distance = math.max(love.graphics.getWidth() * 2, love.graphics.getHeight() * 2)
      if all then
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
    __init = function(self, x, y)
      local sprite = Sprite("enemy/circle.tga", 26, 26, 1, 2)
      _class_0.__parent.__init(self, x, y, sprite)
      self.enemyType = EnemyTypes.turret
      self.score_value = 150
      self.health = 10 + (2.5 * Objectives:getLevel())
      self.max_health = self.health
      self.max_speed = 200 + (5 * Objectives:getLevel())
      self.speed_multiplier = self.max_speed
      self.damage = 2 + (2.5 * Objectives:getLevel())
    end,
    __base = _base_0,
    __name = "TurretEnemy",
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
  TurretEnemy = _class_0
end
