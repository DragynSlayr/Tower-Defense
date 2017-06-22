do
  local _class_0
  local _parent_0 = Wave
  local _base_0 = {
    start = function(self)
      Objectives:spawn(GoalTypes.tesseract)
      if Driver.objects[EntityTypes.goal] then
        for k, g in pairs(Driver.objects[EntityTypes.goal]) do
          g.unlocked = true
        end
      end
      for i = 1, self.spawn_num do
        Objectives:spawn(EnemyTypes.capture)
      end
      return Objectives:spawn(EnemyTypes.turret)
    end,
    entityKilled = function(self, entity)
      if entity.id == EntityTypes.goal and entity.goal_type == GoalTypes.tesseract then
        self.goal_complete = true
      end
    end,
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      if not self.waiting then
        self.parent.time_remaining = self.parent.time_remaining - dt
        self.elapsed = self.elapsed + dt
        self.turret_spawn_timer = self.turret_spawn_timer + dt
        if self.elapsed >= self.spawn_time then
          self.elapsed = 0
          for i = 1, self.spawn_num do
            Objectives:spawn(EnemyTypes.capture)
          end
        end
        if self.turret_spawn_timer >= self.turret_spawn_time then
          self.turret_spawn_timer = 0
          for i = 1, self.turret_spawn_num do
            Objectives:spawn(EnemyTypes.turret)
          end
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
      self.spawn_time = 2
      self.spawn_num = 3
      self.turret_spawn_timer = 0
      self.turret_spawn_time = 5
      self.turret_spawn_num = 3
      self.goal_complete = false
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
