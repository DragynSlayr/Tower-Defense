do
  local _class_0
  local _parent_0 = Wave
  local _base_0 = {
    start = function(self)
      self.emitter = ParticleEmitter(Screen_Size.width * 0.75, Screen_Size.height * 0.5, 0)
      self.emitter:setLifeTimeRange({
        0.1,
        0.4
      })
      return self.emitter:setSizeRange({
        0.1,
        1.0
      })
    end,
    entityKilled = function(self, entity) end,
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      if not self.waiting then
        return self.emitter:update(dt)
      end
    end,
    draw = function(self)
      if self.emitter then
        self.emitter:draw()
      end
      return _class_0.__parent.__base.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      _class_0.__parent.__init(self, parent)
      self.emitter = nil
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
