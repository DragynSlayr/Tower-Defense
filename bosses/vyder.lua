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
      self.speed_multiplier = clamp(self.speed_multiplier + 1, 0, self.max_speed)
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
        if dist < self:getHitBox().radius + (self.attack_range / 2) or self.ai_time >= 1 then
          self.ai_time = 0
          self.ai_phase = self.ai_phase + 1
        end
      elseif 4 == _exp_0 then
        self.speed = Vector(0, 0)
        self.old_trail_delay = self.trail.delay
        self.trail.delay = 0.1
        self.ai_time = 0
        self.ai_phase = self.ai_phase + 1
      elseif 5 == _exp_0 then
        if self.ai_time >= self.fast_poison_time then
          self.ai_time = 0
          self.ai_phase = self.ai_phase + 1
          self.trail.delay = self.old_trail_delay
          self.old_trail_delay = nil
          self.old_sprite = self.sprite
          self.sprite = self.cooldown_sprite
          self.trail:stop()
          self.target_position = Driver:getRandomPosition()
        end
      elseif 6 == _exp_0 then
        _class_0.__parent.__base.update(self, dt)
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
        if self.ai_time >= self.cooldown_time then
          self.ai_time = 0
          self.ai_phase = 1
          self.sprite = self.old_sprite
          self.old_sprite = nil
          return self.trail:start()
        end
      end
    end,
    draw = function(self)
      if DEBUGGING then
        love.graphics.push("all")
        love.graphics.setShader(Driver.shader)
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.circle("fill", self.target_position.x, self.target_position.y, 3, 360)
        love.graphics.setShader()
        love.graphics.pop()
      end
      return _class_0.__parent.__base.draw(self)
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
      self.score_value = 1000
      self.exp_given = self.score_value + (self.score_value * 0.35 * Objectives:getLevel())
      local level = Objectives:getScaling()
      self.health = 2000 + (3000 * level)
      self.max_health = self.health
      self.max_speed = math.min(600, 300 + (100 * level))
      self.speed_multiplier = self.max_speed
      self.damage = 0
      self.boost_multiplier = 3
      self.chase_time = 0
      self.attack_range = 100 * Scale.diag
      self.trail = ParticleEmitter(self.position.x, self.position.y, 0.5, 12, self)
      self.trail.sprite = Sprite("particle/poison.tga", 64, 64, 1, 1.75)
      self.trail.particle_type = ParticleTypes.poison
      self.ai_phase = 1
      self.ai_time = 0
      self.target_position = Driver:getRandomPosition()
      self.cooldown_sprite = Sprite("boss/fox_bat/fox_batAction.tga", 729, 960, 1, 1)
      self.cooldown_sprite:setScale(0.25, 0.25)
      self.cooldown_time = 6
      self.fast_poison_time = 5
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
