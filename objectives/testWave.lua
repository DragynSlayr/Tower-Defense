do
  local _class_0
  local _parent_0 = Wave
  local _base_0 = {
    start = function(self)
      for i = 1, 64 do
        local p = Driver:getRandomPosition()
        local x = (0.95 * p.x) + (0.05 * Screen_Size.half_width)
        local y = (0.95 * p.y) + (0.05 * Screen_Size.half_height)
        local emitter = ParticleEmitter(x, y, math.random() / 2)
        emitter:setLifeTimeRange({
          7.5,
          17.5
        })
        emitter:setSizeRange({
          0.2,
          5
        })
        emitter:setSpeedRange({
          100,
          350
        })
        Driver:addObject(emitter, EntityTypes.particle)
      end
      for i = 1, self.max_count do
        Objectives:spawn((Objectives:getRandomEnemy()), EntityTypes.enemy)
      end
    end,
    entityKilled = function(self, entity)
      if entity.enemyType then
        while self.count < self.max_count do
          Objectives:spawn((Objectives:getRandomEnemy()), EntityTypes.enemy)
          self.count = self.count + 1
        end
      end
    end,
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      local filters = {
        EntityTypes.player,
        EntityTypes.turret
      }
      for k2, filter in pairs(filters) do
        if Driver.objects[filter] then
          for k, v in pairs(Driver.objects[filter]) do
            v.health = v.health + (10 * dt)
          end
        end
      end
      local sum = 0
      if Driver.objects[EntityTypes.particle] then
        for k, v in pairs(Driver.objects[EntityTypes.particle]) do
          sum = sum + #v.objects
        end
      end
      self.parent.message1 = "\tParticles: " .. sum
    end,
    draw = function(self)
      self.count = 0
      local total = 0
      for k, v in pairs(Driver.objects) do
        if k == EntityTypes.enemy then
          self.count = #v
        end
        total = total + #v
      end
      self.parent.message2 = "Objects: " .. total
      return _class_0.__parent.__base.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      _class_0.__parent.__init(self, parent)
      self.count = 0
      self.max_count = 25
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
