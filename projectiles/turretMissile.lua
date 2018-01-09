do
  local _parent_0 = HomingProjectile
  local _base_0 = {
    setTurret = function(self, turret)
      self.turret = turret
      local vec = Vector(self.position.x - self.turret.position.x, self.position.y - self.turret.position.y)
      self.sprite.rotation = vec:getAngle() + math.pi
      self.start_rotation = self.sprite.rotation
    end,
    update = function(self, dt)
      if self.moving then
        return _parent_0.update(self, dt)
      else
        self.sprite:update(dt)
        if self.elapsed < self.wait_time then
          self.elapsed = self.elapsed + dt
          self.sprite.rotation = self.start_rotation + (self.rotation_direction * (2 * math.pi) * (self.elapsed / self.wait_time))
          self.position:add((self.turret.position:multiply(-1)))
          local scale = (500 * self.elapsed) + 750
          self.position:rotate(((self.rotation_direction * 2 * math.pi) / scale))
          return self.position:add(self.turret.position)
        else
          self.moving = true
          self.target = self:findTarget()
          if not self.target then
            return self:kill()
          end
        end
      end
    end,
    draw = function(self)
      if self.moving then
        return _parent_0.draw(self)
      else
        self.sprite:draw(self.position.x, self.position.y)
        if DEBUGGING then
          return self:getHitBox():draw()
        end
      end
    end,
    findTarget = function(self)
      local targets = { }
      if Driver.objects[EntityTypes.enemy] then
        targets = concatTables(targets, Driver.objects[EntityTypes.enemy])
      end
      if Driver.objects[EntityTypes.boss] then
        targets = concatTables(targets, Driver.objects[EntityTypes.boss])
      end
      if Driver.objects[EntityTypes.goal] then
        local goals = {
          GoalTypes.attack,
          GoalTypes.capture
        }
        for k, g in pairs(Driver.objects[EntityTypes.goal]) do
          if tableContains(goals, g.goal_type) then
            table.insert(targets, g)
          end
        end
      end
      return pick(targets)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("projectile/bullet_anim.tga", 32, 16, 0.5, 1.25)
      sprite:setScale(0.95, 1.65)
      _parent_0.__init(self, x, y, nil, sprite)
      self.damage = Stats.turret[3] * 15
      self.speed_multiplier = 500
      self.elapsed = 0
      self.wait_time = 2.5
      self.moving = false
      self.rotation_direction = 1
    end,
    __base = _base_0,
    __name = "TurretMissile",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
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
  TurretMissile = _class_0
end
