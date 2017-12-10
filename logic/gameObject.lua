do
  local _class_0
  local _base_0 = {
    setSpeedOverride = function(self, new_speed, ratio)
      local x, y = new_speed:getComponents()
      self.speed_add = Vector(x, y, true)
      self.speed_override_ratio = ratio
      self.speed_override = true
    end,
    setArmor = function(self, armor, max_armor)
      self.armor = armor
      self.max_armor = max_armor
      self.armored = self.armor > 0
    end,
    getHitBox = function(self)
      local radius = math.min(self.sprite.scaled_height / 2, self.sprite.scaled_width / 2)
      return Circle(self.position.x, self.position.y, radius)
    end,
    onCollide = function(self, object)
      if not self.alive then
        return 
      end
      if not self.shielded then
        local damage = object.damage
        if self.slagged then
          damage = damage * 1.5
        end
        if self.armored then
          self.armor = self.armor - damage
          if self.armor <= 0 then
            self.health = self.health + self.armor
          end
          self.armored = self.armor > 0
        else
          self.health = self.health - damage
        end
        if object.slagging then
          self.slagged = true
        end
        if object.knockback then
          local x, y = object.speed:getComponents()
          local speed = Vector(x, y, true)
          self.position:add(speed:multiply((Scale.diag * 10)))
          local radius = self:getHitBox().radius
          self.position.x = clamp(self.position.x, Screen_Size.border[1] + radius, Screen_Size.border[3] - radius)
          self.position.y = clamp(self.position.y, Screen_Size.border[2] + radius, (Screen_Size.border[4] + Screen_Size.border[2]) - radius)
        end
        self.health = clamp(self.health, 0, self.max_health)
        self.armor = clamp(self.armor, 0, self.max_armor)
      end
    end,
    kill = function(self)
      ScoreTracker:addScore(self.score_value)
      self.alive = false
      self.health = 0
    end,
    update = function(self, dt)
      if not self.alive then
        return 
      end
      if self.shielded then
        self.shield_timer = self.shield_timer + dt
        if self.shield_timer >= self.max_shield_time then
          self.shield_timer = 0
          self.shielded = false
        end
      end
      self.sprite:update(dt)
      self.health = clamp(self.health, 0, self.max_health)
      self.armor = clamp(self.armor, 0, self.max_armor)
      self.armored = self.armor > 0
      if self.slagged then
        self.slag_timer = self.slag_timer + dt
        if self.slag_timer >= self.max_slag_time then
          self.slagged = false
          self.slag_timer = 0
        end
      end
      local start = Vector(self.position.x, self.position.y)
      self.elapsed = self.elapsed + dt
      local start_speed = Vector(self.speed:getComponents())
      if self.speed_override then
        local speed = self.speed_add:multiply(self.speed:getLength() * self.speed_override_ratio)
        self.speed:add(speed)
        self.speed = self.speed:multiply(0.5)
      end
      if self.movement_disabled then
        self.movement_disabled_sprite:update(dt)
      else
        self.position:add(self.speed:multiply(dt))
      end
      self.speed = Vector(start_speed:getComponents())
      local radius = self:getHitBox().radius
      if self.id ~= EntityTypes.wall then
        self.position.x = clamp(self.position.x, Screen_Size.border[1] + radius, Screen_Size.border[3] - radius)
        self.position.y = clamp(self.position.y, Screen_Size.border[2] + radius, (Screen_Size.border[4] + Screen_Size.border[2]) - radius)
      end
      if not self.solid then
        return 
      end
      for k, v in pairs(Driver.objects) do
        for k2, o in pairs(v) do
          if not (self.id == EntityTypes.wall and o.id == EntityTypes.wall) then
            if not ((self.id == EntityTypes.player and o.id == EntityTypes.turret) or (self.id == EntityTypes.turret and o.id == EntityTypes.player)) then
              if o ~= self and o.solid then
                local other = o:getHitBox()
                local this = self:getHitBox()
                if other:contains(this) then
                  self.position = start
                  local dist = other:getCollisionDistance(this)
                  dist = math.sqrt(math.sqrt(math.abs(dist)))
                  local dist_vec = Vector(dist, dist)
                  if self.speed:getLength() > 0 then
                    if self.id ~= EntityTypes.player then
                      self.position:add(dist_vec:multiply(-1))
                    end
                  end
                  if o.speed:getLength() > 0 then
                    if o.id ~= EntityTypes.player then
                      o.position:add(dist_vec)
                    end
                  end
                  if self.contact_damage then
                    o:onCollide(self)
                  end
                  if o.contact_damage then
                    self:onCollide(o)
                  end
                end
              end
            end
          end
        end
      end
    end,
    draw = function(self)
      love.graphics.push("all")
      local old_color = self.sprite.color[2]
      if self.slagged then
        self.sprite.color[2] = 0
      end
      self.sprite:draw(self.position.x, self.position.y)
      self.sprite.color[2] = old_color
      if self.movement_disabled then
        self.movement_disabled_sprite:draw(self.position.x, self.position.y)
      end
      if DEBUGGING then
        self:getHitBox():draw()
      end
      if self.draw_health then
        love.graphics.setShader(Driver.shader)
        love.graphics.setColor(0, 0, 0, 255)
        local radius = self.sprite.scaled_height / 2
        love.graphics.rectangle("fill", (self.position.x - radius) - (3 * Scale.width), (self.position.y + radius) + (3 * Scale.height), (radius * 2) + (6 * Scale.width), 16 * Scale.height)
        love.graphics.setColor(0, 255, 0, 255)
        local ratio = self.health / self.max_health
        love.graphics.rectangle("fill", self.position.x - radius, (self.position.y + radius) + (6 * Scale.height), (radius * 2) * ratio, 10 * Scale.height)
        if self.armored then
          love.graphics.setColor(0, 127, 255, 255)
          ratio = self.armor / self.max_armor
          love.graphics.rectangle("fill", self.position.x - radius, (self.position.y + radius) + (6 * Scale.height), (radius * 2) * ratio, 10 * Scale.height)
        end
        love.graphics.setShader()
      end
      love.graphics.pop()
      if self.shielded then
        return self.shield_sprite:draw(self.position.x, self.position.y)
      end
    end,
    isOnScreen = function(self, bounds)
      if bounds == nil then
        bounds = Screen_Size.bounds
      end
      if not self.alive then
        return false
      end
      local circle = self:getHitBox()
      local x, y = circle.center:getComponents()
      local radius = circle.radius
      local xOn = x - radius >= bounds[1] and x + radius <= bounds[3] - bounds[1]
      local yOn = y - radius >= bounds[2] and y + radius <= bounds[4] - bounds[2]
      return xOn and yOn
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, sprite, x_speed, y_speed)
      if x_speed == nil then
        x_speed = 0
      end
      if y_speed == nil then
        y_speed = 0
      end
      self.position = Vector(x, y)
      self.speed = Vector(x_speed, y_speed)
      self.sprite = sprite
      self.elapsed = 0
      self.health = 5
      self.max_health = self.health
      self.damage = 1
      self.alive = true
      self.id = nil
      self.draw_health = true
      self.score_value = 0
      self.exp_given = 10
      self.shielded = false
      self.shield_timer = 0
      self.max_shield_time = 7
      self.solid = true
      self.contact_damage = false
      self.item_drop_chance = 0.00
      self.speed_override = false
      self.speed_add = Vector(0, 0)
      self.speed_override_ratio = 0
      self.normal_sprite = self.sprite
      self.action_sprite = self.sprite
      self.shield_sprite = Sprite("item/shield.tga", 32, 32, 1, 1)
      local x_scale = self.sprite.scaled_width / 32
      local y_scale = self.sprite.scaled_height / 32
      self.shield_sprite:setScale(x_scale * 1.5, y_scale * 1.5)
      self:setArmor(0, self.max_health)
      self.slagged = false
      self.slagging = false
      self.slag_timer = 0
      self.max_slag_time = 2
      self.knockback = false
      self.movement_disabled = false
      self.movement_disabled_sprite = Sprite("effect/emp.tga", 32, 32, 1, 1)
      x_scale = self.sprite.scaled_width / 32
      y_scale = self.sprite.scaled_height / 32
      return self.movement_disabled_sprite:setScale(x_scale * 1.5, y_scale * 1.5)
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
