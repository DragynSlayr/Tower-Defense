do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    getHitBox = function(self)
      local radius = math.max(self.sprite.scaled_height / 2, self.sprite.scaled_width / 2)
      return Circle(self.position.x, self.position.y, radius)
    end,
    update = function(self, dt)
      if not self.alive then
        return 
      end
      _class_0.__parent.__base.update(self, dt)
      if Upgrade.turret_special[2] then
        if self.health <= (self.max_health / 2) and self.shield_available then
          self.shield_available = false
          self.shielded = true
          if Driver.objects[EntityTypes.player] then
            for k, v in pairs(Driver.objects[EntityTypes.player]) do
              v.shielded = true
            end
          end
          if Driver.objects[EntityTypes.goal] then
            for k, v in pairs(Driver.objects[EntityTypes.goal]) do
              if v.goal_type == GoalTypes.defend then
                v.shielded = true
              end
            end
          end
        end
      end
      if Upgrade.turret_special[3] then
        if Driver.objects[EntityTypes.enemy] then
          for k, e in pairs(Driver.objects[EntityTypes.enemy]) do
            local enemy = e:getHitBox()
            local turret = self:getHitBox()
            turret.radius = turret.radius + self.range
            if enemy:contains(turret) then
              local bullet = Bullet(self.position.x, self.position.y - self.sprite.scaled_height / 2 + 10, e, self.damage)
              Driver:addObject(bullet, EntityTypes.bullet)
            end
          end
        end
      else
        if self.target then
          local enemy = self.target:getHitBox()
          local turret = self:getHitBox()
          local dist = Vector(enemy.center.x - turret.center.x, enemy.center.y - turret.center.y)
          if dist:getLength() > self.range then
            self.target = nil
            return self:findTarget()
          else
            if self.target then
              local bullet = Bullet(self.position.x, self.position.y - self.sprite.scaled_height / 2 + 10, self.target, self.damage)
              Driver:addObject(bullet, EntityTypes.bullet)
              if self.target.health <= 0 then
                self.target = nil
                return self:findTarget()
              end
            end
          end
        else
          return self:findTarget()
        end
      end
    end,
    findTarget = function(self)
      if not self.alive then
        return 
      end
      if Driver.objects[EntityTypes.enemy] then
        for k, v in pairs(Driver.objects[EntityTypes.enemy]) do
          local enemy = v:getHitBox()
          local turret = self:getHitBox()
          turret.radius = turret.radius + self.range
          if enemy:contains(turret) then
            if v.alive then
              self.target = v
              break
            end
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
        love.graphics.setColor(255, 0, 0, 127)
        love.graphics.circle("fill", self.position.x, self.position.y, self.range, 360)
        love.graphics.pop()
      end
      return _class_0.__parent.__base.draw(self)
    end,
    drawFaded = function(self)
      if not self.alive then
        return 
      end
      love.graphics.push("all")
      love.graphics.setColor(100, 100, 100, 127)
      love.graphics.circle("fill", self.position.x, self.position.y, self.range, 360)
      self.sprite:draw(self.position.x, self.position.y)
      return love.graphics.pop()
    end,
    isOnScreen = function(self)
      if not self.alive then
        return false
      end
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
      self.max_health = Stats.turret[1]
      self.damage = Stats.turret[3]
      self.health = self.max_health
      self.range = range
      self.target = nil
      self.id = EntityTypes.turret
      self.draw_health = false
      self.shield_available = true
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
