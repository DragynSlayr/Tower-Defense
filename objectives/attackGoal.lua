do
  local _parent_0 = GameObject
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("objective/portal.tga", 56, 56, 1, 1.1)
      local color = {
        127,
        0,
        100,
        255
      }
      sprite:setColor(color)
      sprite:setRotationSpeed(math.pi * -0.75)
      _parent_0.__init(self, x, y, sprite)
      self.id = EntityTypes.goal
      self.goal_type = GoalTypes.attack
      self.health = math.min(690, 50 + (107 * Objectives:getScaling()))
      self.max_health = self.health
      self.item_drop_chance = 0.2
      self.score_value = 100
      self.exp_given = self.score_value + (self.score_value * 0.25 * Objectives:getLevel())
    end,
    __base = _base_0,
    __name = "AttackGoal",
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
  AttackGoal = _class_0
end
