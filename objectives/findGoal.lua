do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      if self.elapsed >= self.max_time then
        self.elapsed = 0
        local goal = Objectives:spawn(GoalTypes.find)
        Driver:removeObject(goal, false)
        self.position = goal.position
      end
    end,
    onCollide = function(self, object)
      if object.id == EntityTypes.player then
        self.health = 0
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("player/sentry.tga", 26, 26, 1, 2)
      _class_0.__parent.__init(self, x, y, sprite)
      self.id = EntityTypes.goal
      self.goal_type = GoalTypes.find
      self.draw_health = false
      self.max_time = ((-4 / 30) * Objectives:getLevel()) + 5
      self.max_time = clamp(self.max_time, 1, 5)
    end,
    __base = _base_0,
    __name = "FindGoal",
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
  FindGoal = _class_0
end
