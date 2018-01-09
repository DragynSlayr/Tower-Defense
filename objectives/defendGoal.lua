do
  local _parent_0 = GameObject
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("objective/defend.tga", 26, 27, 1, 2)
      local color = {
        0,
        127,
        100,
        255
      }
      _parent_0.__init(self, x, y, sprite)
      self.id = EntityTypes.goal
      self.goal_type = GoalTypes.defend
      self.health = math.min(185, 20 + (27.5 * Objectives:getScaling()))
      self.max_health = self.health
    end,
    __base = _base_0,
    __name = "DefendGoal",
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
  DefendGoal = _class_0
end
