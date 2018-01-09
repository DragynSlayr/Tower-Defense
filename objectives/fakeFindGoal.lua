do
  local _parent_0 = FindGoal
  local _base_0 = {
    draw = function(self)
      if self.trail then
        return self.trail:draw()
      end
    end,
    onCollide = function(self, object) end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, x, y)
      _parent_0.__init(self, x, y)
      self.goal_type = GoalTypes.fake_find
      self.solid = false
    end,
    __base = _base_0,
    __name = "FakeFindGoal",
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
  FakeFindGoal = _class_0
end
