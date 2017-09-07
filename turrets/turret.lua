do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    getStats = function(self)
      local stats = { }
      stats[1] = self.max_health
      stats[2] = self.range
      stats[3] = self.damage
      stats[4] = self.cooldown
      stats[5] = self.attack_speed
      return stats
    end,
    getAttackHitBox = function(self)
      local radius = math.max(self.sprite.scaled_height / 2, self.sprite.scaled_width / 2)
      return Circle(self.position.x, self.position.y, radius)
    end,
    getHitBox = function(self)
      return Rectangle(self.position.x - (self.sprite.scaled_width / 2), self.position.y - (self.sprite.scaled_height / 2), self.sprite.scaled_width, self.sprite.scaled_height)
    end,
    update = function(self, dt)
      if not self.alive then
        return 
      end
      self.sprite.shader:send("health", self.health / self.max_health)
      self.sprite.should_shade = Objectives.mode.mode_type ~= ModeTypes.dark
      _class_0.__parent.__base.update(self, dt)
      if Upgrade.turret_special[2] then
        if self.health <= (self.max_health / 2) and self.shield_available then
          self.shield_available = false
          if Driver.objects[EntityTypes.turret] then
            for k, t in pairs(Driver.objects[EntityTypes.turret]) do
              t.shielded = true
            end
          end
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
      local attacked = false
      self.attack_timer = self.attack_timer + dt
      if self.attack_timer >= self.attack_speed then
        if Upgrade.turret_special[3] then
          local filters = {
            EntityTypes.enemy,
            EntityTypes.boss
          }
          for k2, filter in pairs(filters) do
            if Driver.objects[filter] then
              for k, e in pairs(Driver.objects[filter]) do
                local enemy = e:getHitBox()
                local turret = self:getAttackHitBox()
                turret.radius = turret.radius + self.range
                if enemy:contains(turret) then
                  local bullet = Bullet(self.position.x, self.position.y - self.sprite.scaled_height / 2 + 10, e, self.damage)
                  Driver:addObject(bullet, EntityTypes.bullet)
                  attacked = true
                end
              end
            end
          end
        else
          if self.target and self.target.alive then
            local enemy = self.target:getHitBox()
            local turret = self:getHitBox()
            local dist = Vector(enemy.center.x - turret.center.x, enemy.center.y - turret.center.y)
            if dist:getLength() > self.range then
              self.target = nil
              self:findTarget()
            else
              if self.target then
                local bullet = Bullet(self.position.x, self.position.y - self.sprite.scaled_height / 2 + 10, self.target, self.damage)
                Driver:addObject(bullet, EntityTypes.bullet)
                attacked = true
                if self.target.health <= 0 then
                  self.target = nil
                  self:findTarget()
                end
              end
            end
          else
            self:findTarget()
          end
        end
      end
      if attacked then
        self.attack_timer = 0
      end
    end,
    findTarget = function(self)
      local closest = nil
      local closest_distance = math.max(love.graphics.getWidth() * 2, love.graphics.getHeight() * 2)
      if Driver.objects[EntityTypes.enemy] then
        for k, v in pairs(Driver.objects[EntityTypes.enemy]) do
          local player = v:getHitBox()
          local enemy = self:getAttackHitBox()
          local dist = Vector(enemy.center.x - player.center.x, enemy.center.y - player.center.y)
          if dist:getLength() < closest_distance then
            closest_distance = dist:getLength()
            closest = v
          end
        end
      end
      if Driver.objects[EntityTypes.boss] then
        for k, v in pairs(Driver.objects[EntityTypes.boss]) do
          local turret = v:getHitBox()
          local enemy = self:getAttackHitBox()
          local dist = Vector(enemy.center.x - turret.center.x, enemy.center.y - turret.center.y)
          if dist:getLength() < closest_distance then
            closest_distance = dist:getLength()
            closest = v
          end
        end
      end
      self.target = closest
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
      _class_0.__parent.__base.draw(self)
      love.graphics.push("all")
      love.graphics.setShader(Driver.shader)
      local font = Renderer.small_font
      love.graphics.setFont(font)
      local h = string.format("%.1f", self.health)
      local m = string.format("%.1f", self.max_health)
      local message = h .. " / " .. m
      local width = (font:getWidth("185.0 / 185.0")) + (5 * Scale.width)
      local height = font:getHeight()
      love.graphics.setColor(0, 0, 0, 50)
      love.graphics.rectangle("fill", self.position.x - (width / 2) - (2 * Scale.width), self.position.y + (self.sprite.scaled_height / 2), width + (4 * Scale.width), height + (2 * Scale.height), 4 * Scale.diag)
      love.graphics.setColor(0, 255, 0, 255)
      love.graphics.printf(message, self.position.x - (width / 2), self.position.y + (self.sprite.scaled_height / 2), width, "center")
      love.graphics.setShader()
      return love.graphics.pop()
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
    __init = function(self, x, y, range, sprite, cooldown)
      _class_0.__parent.__init(self, x, y, sprite, 0, 0)
      self.max_health = Stats.turret[1]
      self.damage = Stats.turret[3]
      self.attack_speed = Stats.turret[5]
      self.health = self.max_health
      self.range = range
      self.attack_timer = 0
      self.cooldown = cooldown
      self.target = nil
      self.id = EntityTypes.turret
      self.draw_health = false
      self.shield_available = true
      return self.sprite:setShader(love.graphics.newShader("shaders/health.fs"))
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
