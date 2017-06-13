do
  local _class_0
  local _base_0 = {
    getHitBox = function(self)
      local radius = math.min(self.sprite.scaled_height / 2, self.sprite.scaled_width / 2)
      return Circle(self.position.x, self.position.y, radius)
    end,
    onCollide = function(self, object)
      if not self.alive then
        return 
      end
      if not self.shielded then
        self.health = self.health - object.damage
      end
    end,
    kill = function(self)
      local score = SCORE + self.score_value
      SCORE = score
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
      local start = Vector(self.position.x, self.position.y)
      self.elapsed = self.elapsed + dt
      self.position:add(self.speed:multiply(dt))
      local radius = self:getHitBox().radius
      self.position.x = clamp(self.position.x, Screen_Size.border[1] + radius, Screen_Size.border[3] - radius)
      self.position.y = clamp(self.position.y, Screen_Size.border[2] + radius, (Screen_Size.border[4] + Screen_Size.border[2]) - radius)
      if self.id == EntityTypes.bullet or self.id == EntityTypes.bomb or self.id == EntityTypes.particle then
        return 
      end
      for k, v in pairs(Driver.objects) do
        for k2, o in pairs(v) do
          if not (self.id == EntityTypes.wall and o.id == EntityTypes.wall) then
            if not ((self.id == EntityTypes.player and o.id == EntityTypes.turret) or (self.id == EntityTypes.turret and o.id == EntityTypes.player)) then
              if o ~= self and not (o.id == EntityTypes.bullet or o.id == EntityTypes.bomb or o.id == EntityTypes.particle) then
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
                end
              end
            end
          end
        end
      end
    end,
    draw = function(self)
      love.graphics.push("all")
      self.sprite:draw(self.position.x, self.position.y)
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
      local xOn = x - radius >= bounds[1] and x + radius <= bounds[3]
      local yOn = y - radius >= bounds[2] and y + radius <= bounds[4]
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
      self.shielded = false
      self.shield_timer = 0
      self.max_shield_time = 7
      self.normal_sprite = self.sprite
      self.action_sprite = self.sprite
      self.shield_sprite = Sprite("shield.tga", 32, 32, 1, 1)
      local x_scale = self.sprite.scaled_width / 32
      local y_scale = self.sprite.scaled_height / 32
      return self.shield_sprite:setScale(x_scale * 1.5, y_scale * 1.5)
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
