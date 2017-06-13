do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      if self.speed:getLength() > 0 then
        self.position:add(self.speed:multiply(dt))
      else
        self.position = self.parent.position
      end
      local change = Vector(self.last_position.x - self.position.x, self.last_position.y - self.position.y)
      if change:getLength() > 20 then
        self.last_position = Vector(self.parent.position:getComponents())
        local particle = Particle(self.position.x, self.position.y, self.sprite:getCopy(), 200, 50, 2.5)
        return Driver:addObject(particle, EntityTypes.particle)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, sprite, parent)
      _class_0.__parent.__init(self, x, y, sprite:getCopy())
      self.parent = parent
      self.last_position = Vector(self.parent.position:getComponents())
      self.position = self.last_position
    end,
    __base = _base_0,
    __name = "ParticleTrail",
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
  ParticleTrail = _class_0
end
