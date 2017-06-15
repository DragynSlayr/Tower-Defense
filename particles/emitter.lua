do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    start = function(self)
      self.emitting = true
    end,
    stop = function(self)
      self.emitting = false
    end,
    update = function(self, dt)
      if self.parent then
        if self.parent.alive then
          self.position = self.parent.position
        else
          self:kill()
        end
      end
      self.elapsed = self.elapsed + dt
      if self.emitting and self.elapsed >= self.delay then
        self.elapsed = 0
        local particle = Particle(self.position.x, self.position.y, self.sprite, 200, 50, self.life_time)
        local x, y = getRandomUnitStart()
        particle.speed = Vector(x, y, true)
        particle.speed = particle.speed:multiply(250 * Scale.diag)
        particle:setShader(self.shader, true)
        return Driver:addObject(particle, EntityTypes.particle)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, delay, life_time, parent)
      local sprite = Sprite("block.tga", 32, 32, 1, 1)
      sprite:setColor({
        0,
        0,
        0,
        0
      })
      _class_0.__parent.__init(self, x, y, sprite)
      self.emitting = true
      self.delay = delay
      self.life_time = life_time
      self.id = EntityTypes.particle
      self.draw_health = false
      self.parent = parent
      self.shader = nil
      self.sprite = Sprite("particle.tga", 32, 32, 1, 0.5)
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
