do
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      if self.speed:getLength() > 0 then
        self.position:add(self.speed:multiply(dt))
      else
        self.position = self.parent.position
      end
      self.sprite.rotation = self.parent.sprite.rotation
      for k, v in pairs(self.objects) do
        v:update(dt)
        if v.health <= 0 then
          table.remove(self.objects, k)
        end
      end
      local change = Vector(self.last_position.x - self.position.x, self.last_position.y - self.position.y)
      if change:getLength() >= self.average_size then
        self.last_position = Vector(self.parent.position:getComponents())
        local particle
        local _exp_0 = self.particle_type
        if ParticleTypes.normal == _exp_0 then
          particle = Particle(self.position.x, self.position.y, self.sprite, 255, 0, self.life_time)
        elseif ParticleTypes.poison == _exp_0 then
          particle = PoisonParticle(self.position.x, self.position.y, self.sprite, 255, 0, self.life_time)
        elseif ParticleTypes.enemy_poison == _exp_0 then
          particle = EnemyPoisonParticle(self.position.x, self.position.y, self.sprite, 255, 0, self.life_time)
        end
        return table.insert(self.objects, particle)
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
  local _class_0 = setmetatable({
    __init = function(self, x, y, sprite, parent)
      _parent_0.__init(self, x, y, sprite:getCopy())
      self.objects = { }
      self.parent = parent
      self.solid = false
      self.last_position = Vector(self.parent.position:getComponents())
      self.position = self.last_position
      self.life_time = 1
      self.average_size = (self.sprite.scaled_width + self.sprite.scaled_height) / 8
      self.particle_type = ParticleTypes.normal
    end,
    __base = _base_0,
    __name = "ParticleTrail",
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
  ParticleTrail = _class_0
end
