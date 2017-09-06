do
  local _class_0
  local _parent_0 = Wave
  local _base_0 = {
    start = function(self)
      for i = 1, 1 do
        local emitter = ParticleEmitter(Screen_Size.width * 0.25, Screen_Size.height * 0.5, 0.2)
        emitter:setLifeTimeRange({
          2,
          5
        })
        emitter:setSizeRange({
          1,
          1
        })
        emitter:setSpeedRange({
          -20,
          20
        })
        Driver:addObject(emitter, EntityTypes.particle)
      end
      local image = love.graphics.newImage("assets/sprites/particle/particle.tga")
      self.system = love.graphics.newParticleSystem(image, 50)
      self.system:setParticleLifetime(2, 5)
      self.system:setEmissionRate(5)
      self.system:setLinearAcceleration(-20, -20, 20, 20)
      return self.system:setColors(255, 255, 255, 255, 255, 255, 255, 0)
    end,
    entityKilled = function(self, entity) end,
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      if not self.waiting then
        return self.system:update(dt)
      end
    end,
    draw = function(self)
      if self.system then
        love.graphics.draw(self.system, Screen_Size.width * 0.75, Screen_Size.height * 0.5)
      end
      return _class_0.__parent.__base.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      _class_0.__parent.__init(self, parent)
      self.system = nil
    end,
    __base = _base_0,
    __name = "TestWave",
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
  TestWave = _class_0
end
