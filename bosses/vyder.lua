do
  local _class_0
  local _parent_0 = Boss
  local _base_0 = {
    getHitBox = function(self)
      local radius = math.min(self.sprite.scaled_height / 2, self.sprite.scaled_width / 2)
      radius = radius * 0.75
      return Circle(self.position.x, self.position.y + (25 * Scale.height), radius)
    end,
    update = function(self, dt)
      self.ai_time = self.ai_time + dt
      local _exp_0 = self.ai_phase
      if 1 == _exp_0 then
        self.speed = Vector(self.target_position.x - self.position.x, self.target_position.y - self.position.y)
        local dist = self.speed:getLength()
        self.speed:toUnitVector()
        self.speed = self.speed:multiply(self.speed_multiplier)
        _class_0.__parent.__base.update(self, dt)
        self.chase_time = self.chase_time + dt
        if dist <= self:getHitBox().radius or self.chase_time >= 3 then
          self.chase_time = 0
          self.target_position = Driver:getRandomPosition()
        end
        if self.ai_time >= 10 then
          self.ai_time = 0
          self.ai_phase = self.ai_phase + 1
        end
      elseif 2 == _exp_0 then
        local targets = { }
        if Driver.objects[EntityTypes.player] then
          targets = concatTables(targets, Driver.objects[EntityTypes.player])
        end
        if Driver.objects[EntityTypes.turret] then
          targets = concatTables(targets, Driver.objects[EntityTypes.turret])
        end
        local target = pick(targets)
        self.target_position = target.position
        self.ai_time = 0
        self.ai_phase = self.ai_phase + 1
      elseif 3 == _exp_0 then
        self.speed = Vector(self.target_position.x - self.position.x, self.target_position.y - self.position.y)
        local dist = self.speed:getLength()
        self.speed:toUnitVector()
        self.speed = self.speed:multiply(self.speed_multiplier * self.boost_multiplier)
        _class_0.__parent.__base.update(self, dt)
        self.chase_time = self.chase_time + dt
        if dist < self:getHitBox().radius + (self.attack_range / 2) or self.ai_time >= 5 then
          self.ai_time = 0
          self.ai_phase = self.ai_phase + 1
        end
      elseif 4 == _exp_0 then
        self.speed = Vector(0, 0)
        self.sprite = self.action_sprite
        self.ai_time = 0
        self.ai_phase = self.ai_phase + 1
      elseif 5 == _exp_0 then
        _class_0.__parent.__base.update(self, dt)
        if Driver.objects[EntityTypes.player] then
          for k, v in pairs(Driver.objects[EntityTypes.player]) do
            local player = v:getHitBox()
            local boss = self:getHitBox()
            boss.radius = boss.radius + self.attack_range
            if player:contains(boss) then
              v:onCollide(self)
            end
          end
        end
        if Driver.objects[EntityTypes.turret] then
          for k, v in pairs(Driver.objects[EntityTypes.turret]) do
            local turret = v:getAttackHitBox()
            local boss = self:getHitBox()
            boss.radius = boss.radius + self.attack_range
            if turret:contains(boss) then
              v:onCollide(self)
            end
          end
        end
      end
    end,
    draw = function(self)
      _class_0.__parent.__base.draw(self)
      love.graphics.push("all")
      love.graphics.setShader(Driver.shader)
      love.graphics.setColor(255, 0, 0, 255)
      love.graphics.circle("fill", self.target_position.x, self.target_position.y, 3, 360)
      love.graphics.setShader()
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("boss/fox_bat/fox_bat.tga", 729, 960, 1, 1)
      sprite:setScale(0.25, 0.25)
      _class_0.__parent.__init(self, x, y, sprite)
      self.bossType = BossTypes.vyder
      self.health = 300
      self.max_health = self.health
      self.speed_multiplier = 200
      self.boost_multiplier = 3
      self.chase_time = 0
      self.damage = 5 / 60
      self.attack_range = 100 * Scale.diag
      sprite = Sprite("poison.tga", 64, 64, 1, 1.75)
      self.trail = ParticleEmitter(self.position.x, self.position.y, 0.2, 3, self)
      self.trail.sprite = sprite
      self.trail.particle_type = ParticleTypes.poison
      self.trail.moving_particles = false
      self.ai_phase = 1
      self.ai_time = 0
      self.target_position = Driver:getRandomPosition()
      local splitted = split(self.normal_sprite.name, ".")
      local name = splitted[1] .. "Action." .. splitted[2]
      local height, width, _, scale = self.normal_sprite:getProperties()
      self.action_sprite = ActionSprite(name, height, width, 0.5, 1, self, function(self)
        self.parent.ai_phase = 1
        self.parent.ai_time = 0
        self.parent.target_position = Driver:getRandomPosition()
      end)
      local x_scale = self.normal_sprite.scaled_width / (self.normal_sprite.width * Scale.width)
      local y_scale = self.normal_sprite.scaled_height / (self.normal_sprite.height * Scale.height)
      return self.action_sprite:setScale(x_scale, y_scale)
    end,
    __base = _base_0,
    __name = "BossVyder",
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
  BossVyder = _class_0
end
