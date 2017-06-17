do
  local _class_0
  local _parent_0 = Wave
  local _base_0 = {
    start = function(self)
      for k, p in pairs(self.point_positions) do
        local goal = CaptureGoal(p.x, p.y)
        goal.num = k
        Driver:addObject(goal, EntityTypes.goal)
      end
      self.point_positions = nil
      for i = 1, self.spawn_num do
        Objectives:spawn(EnemyTypes.capture)
      end
      return Objectives:spawn(EnemyTypes.strong)
    end,
    entityKilled = function(self, entity)
      if entity.id == EntityTypes.goal then
        if entity.killer then
          if entity.killer == EntityTypes.player then
            self.captured = self.captured + 1
          else
            self.dead = self.dead + 1
          end
        end
      end
    end,
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      if not self.waiting then
        self.elapsed = self.elapsed + dt
        if self.elapsed >= self.spawn_time then
          self.elapsed = 0
          for i = 1, self.spawn_num do
            Objectives:spawn(EnemyTypes.capture)
          end
          Objectives:spawn(EnemyTypes.strong)
        end
      end
      if self.dead > 1 then
        Driver.game_over()
      end
      if self.captured >= self.target - 1 then
        self.complete = true
        if Driver.objects[EntityTypes.goal] then
          for k, o in pairs(Driver.objects[EntityTypes.goal]) do
            Driver:removeObject(o, false)
          end
        end
      end
    end,
    draw = function(self)
      local message = "points"
      local num = self.target - self.captured
      if num == 1 then
        message = "point"
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
      self.spawn_num = {
        3,
        3,
        4
      }
      self.spawn_num = self.spawn_num[self.parent.wave_count]
      local x_space = 100
      local y_space = 100
      self.point_positions = {
        Vector(x_space * Scale.width, Screen_Size.height - Screen_Size.border[2] - (y_space * Scale.height)),
        Vector(Screen_Size.width - (x_space * Scale.width), Screen_Size.height - Screen_Size.border[2] - (y_space * Scale.height)),
        Vector(Screen_Size.width / 2, Screen_Size.border[2] + (y_space * Scale.height))
      }
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
