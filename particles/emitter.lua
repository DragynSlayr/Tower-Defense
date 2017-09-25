do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    resetProperties = function(self)
      self.properties.max_particles = 50
    end,
    start = function(self)
      self.emitting = true
    end,
    stop = function(self)
      self.emitting = false
    end,
    setSizeRange = function(self, range)
      self.size_range = range
    end,
    setLifeTimeRange = function(self, range)
      self.life_time_range = range
    end,
    setSpeedRange = function(self, range)
      self.speed_range = range
    end,
    setVelocity = function(self, velocity)
      self.velocity = velocity
    end,
    update = function(self, dt)
      if self.parent then
        if self.parent.alive then
          self.position = self.parent.position
        else
          self.health = 0
        end
      end
      for k, v in pairs(self.objects) do
        v:update(dt)
        if v.health <= 0 then
          table.remove(self.objects, k)
        end
      end
      self.elapsed = self.elapsed + dt
      if self.emitting and self.elapsed >= self.delay then
        if #self.objects + 1 <= self.properties.max_particles then
          self.elapsed = 0
          local life_time = map(math.random(), 0, 1, self.life_time_range[1], self.life_time_range[2])
          local scale = map(math.random(), 0, 1, self.size_range[1], self.size_range[2])
          local sprite = self.sprite:getCopy()
          sprite:scaleUniformly(scale)
          local particle
          local _exp_0 = self.particle_type
          if ParticleTypes.normal == _exp_0 then
            particle = Particle(self.position.x, self.position.y, sprite, 255, 0, life_time)
          elseif ParticleTypes.poison == _exp_0 then
            particle = PoisonParticle(self.position.x, self.position.y, sprite, 255, 0, life_time)
          elseif ParticleTypes.enemy_poison == _exp_0 then
            particle = EnemyPoisonParticle(self.position.x, self.position.y, sprite, 255, 0, life_time)
          end
          if self.moving_particles then
            local v = getRandomUnitStart()
            particle.speed = Vector(v.x, v.y, true)
            local speed = map(math.random(), 0, 1, self.speed_range[1], self.speed_range[2])
            particle.speed = particle.speed:multiply(speed * Scale.diag)
          else
            particle.speed = self.velocity
          end
          particle:setShader(self.shader, true)
          return table.insert(self.objects, particle)
        end
      end
    end,
    draw = function(self)
      for k, v in pairs(self.objects) do
        v:draw()
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, delay, life_time, parent)
      if delay == nil then
        delay = 1
      end
      if life_time == nil then
        life_time = 1
      end
      if parent == nil then
        parent = nil
      end
      local sprite = Sprite("particle/particle.tga", 32, 32, 1, 1)
      _class_0.__parent.__init(self, x, y, sprite)
      self.objects = { }
      self.properties = { }
      self:resetProperties()
      self.solid = false
      self.emitting = true
      self.delay = delay
      self.life_time = life_time
      self.id = EntityTypes.particle
      self.draw_health = false
      self.parent = parent
      self.shader = nil
      self.particle_type = ParticleTypes.normal
      self.moving_particles = true
      self.life_time_range = {
        self.life_time,
        self.life_time
      }
      self.size_range = {
        1,
        1
      }
      self.speed_range = {
        250,
        250
      }
      self.velocity = Vector(0, 0)
    end,
    __base = _base_0,
    __name = "ParticleEmitter",
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
  ParticleEmitter = _class_0
end
