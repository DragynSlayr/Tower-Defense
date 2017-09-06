do
  local _class_0
  local _parent_0 = Wave
  local _base_0 = {
    start = function(self)
      local tess = TesseractGoal(Screen_Size.half_width, Screen_Size.height * 0.75)
      if Driver.objects[EntityTypes.goal] then
        local num = math.random(1, #Driver.objects[EntityTypes.goal])
        for k, g in pairs(Driver.objects[EntityTypes.goal]) do
          if k == num then
            self.trail.position = g.position
          end
          g.unlocked = true
          g.tesseract = tess
          g.capture_amount = g.capture_amount / 2
        end
      end
      for i = 1, self.spawn_num do
        Objectives:spawn(EnemyTypes.capture)
      end
      for i = 1, self.turret_spawn_num do
        Objectives:spawn(EnemyTypes.turret)
      end
      return Driver:addObject(tess, EntityTypes.goal)
    end,
    finish = function(self)
      _class_0.__parent.__base.finish(self)
      return Driver:removeObject(self.trail, false)
    end,
    entityKilled = function(self, entity)
      if entity.id == EntityTypes.goal and entity.goal_type == GoalTypes.tesseract then
        self.goal_complete = true
        if Driver.objects[EntityTypes.goal] then
          for k, g in pairs(Driver.objects[EntityTypes.goal]) do
            g.tesseract = nil
          end
        end
      elseif entity.id == EntityTypes.enemy and entity.enemyType == EnemyTypes.turret then
        return Objectives:spawn(EnemyTypes.turret)
      end
    end,
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      if not self.waiting then
        self.parent.time_remaining = self.parent.time_remaining - dt
        self.elapsed = self.elapsed + dt
        self.timer = self.timer + dt
        if self.elapsed >= self.spawn_time then
          self.elapsed = 0
          for i = 1, self.spawn_num do
            Objectives:spawn(EnemyTypes.capture)
          end
        end
        if self.timer >= self.movement_delay then
          self.timer = 0
          local num = math.random(1, #Driver.objects[EntityTypes.goal] - 1)
          self.trail.position = Driver.objects[EntityTypes.goal][num].position
          self.movement_delay = math.random(3, 8)
        end
      end
      if self.parent.time_remaining <= 0 then
        Driver.game_over()
      end
      if self.goal_complete then
        self.complete = true
        Driver:killEnemies()
        if Driver.objects[EntityTypes.goal] then
          for k, o in pairs(Driver.objects[EntityTypes.goal]) do
            o.unlocked = false
          end
        end
      end
    end,
    draw = function(self)
      local message = "seconds"
      local num = math.floor(self.parent.time_remaining)
      if num == 1 then
        message = "second"
      end
      self.parent.message1 = "\t" .. num .. " " .. message .. " remaining!"
      return _class_0.__parent.__base.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      _class_0.__parent.__init(self, parent)
      self.target = 3
      self.captured = 0
      self.dead = 0
      self.spawn_time = 3
      self.spawn_num = 3
      self.turret_spawn_num = 3
      self.goal_complete = false
      local sprite = Sprite("particle/poison.tga", 64, 64, 1, 0.25)
      self.trail = ParticleEmitter(0, 0, 1 / 4)
      self.trail.sprite = sprite
      self.trail.particle_type = ParticleTypes.poison
      self.trail:setSizeRange({
        1,
        1
      })
      self.trail:setSpeedRange({
        100,
        175
      })
      self.trail:setLifeTimeRange({
        0.25,
        0.75
      })
      self.trail.solid = false
      Driver:addObject(self.trail, EntityTypes.particle)
      self.timer = 0
      self.movement_delay = math.random(3, 8)
    end,
    __base = _base_0,
    __name = "CaptureWave",
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
  CaptureWave = _class_0
end
