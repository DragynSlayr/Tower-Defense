do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    kill = function(self)
      _class_0.__parent.__base.kill(self)
      self.trail.health = 0
      for k, v in pairs(self.children) do
        v.health = 0
        v.update = function(self, dt)
          return _class_0.__parent.__base.kill(self, dt)
        end
      end
    end,
    update = function(self, dt)
      local _exp_0 = self.ai_phase
      if 1 == _exp_0 then
        local dist_x = self.target.position.x - self.position.x
        local dist_y = self.target.position.y - self.position.y
        self.speed = Vector(dist_x, dist_y)
        self.speed:toUnitVector()
        self.speed = self.speed:multiply(self.speed_multiplier)
        self.trail.position = self.position
        if self.elapsed >= self.wait_time and (Vector(dist_x, dist_y)):getLength() <= (300 * Scale.diag) then
          self.ai_phase = self.ai_phase + 1
          self.speed = Vector(0, 0)
          self.elapsed = 0
        end
      elseif 2 == _exp_0 then
        if self.elapsed >= self.end_delay then
          self.elapsed = 0
          local te = CloudEnemy(self.position.x, self.position.y)
          te.trail.position = te.position
          te.draw_health = false
          te.item_drop_chance = 0
          te.update = function(self, dt)
            self.health = self.max_health
            return _class_0.__parent.__base.update(self, dt)
          end
          Driver:addObject(te, EntityTypes.enemy)
          table.insert(self.children, te)
          self.ai_phase = 1
        end
      end
      return _class_0.__parent.__base.update(self, dt)
    end,
    draw = function(self)
      return _class_0.__parent.__base.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("enemy/cloud.tga", 32, 32, 1, 1.25)
      _class_0.__parent.__init(self, x, y, sprite)
      self.id = EntityTypes.enemy
      self.value = 1
      self.item_drop_chance = 0.10
      self.solid = false
      self.health = math.min(1000, 36 + (84.5 * Objectives:getScaling()))
      self.max_health = self.health
      self.max_speed = math.min(500 * Scale.diag, (175 + (54 * Objectives:getScaling())) * Scale.diag)
      self.speed_multiplier = self.max_speed
      if Driver.objects[EntityTypes.player] and #Driver.objects[EntityTypes.player] > 0 then
        self.target = Driver.objects[EntityTypes.player][1]
      else
        self.health = 0
        return 
      end
      self.end_delay = 1.5
      self.wait_time = 4
      self.ai_phase = 1
      self.children = { }
      sprite = Sprite("particle/blip.tga", 16, 16, 1, 1)
      sprite:setColor({
        127,
        127,
        127,
        200
      })
      self.trail = ParticleEmitter(0, 0, 1 / 15, 0.5)
      self.trail.sprite = sprite
      self.trail.particle_type = ParticleTypes.poison
      self.trail:setSizeRange({
        0.75,
        0.95
      })
      self.trail:setSpeedRange({
        200,
        200
      })
      self.trail:setLifeTimeRange({
        0.3,
        0.7
      })
      self.trail.solid = false
      return Driver:addObject(self.trail, EntityTypes.particle)
    end,
    __base = _base_0,
    __name = "CloudEnemy",
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
  CloudEnemy = _class_0
end
