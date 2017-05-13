do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("boss/eye/eye.tga", 56, 56, 1, 1.1)
      local color = {
        127,
        0,
        100,
        255
      }
      sprite:setColor(color)
      sprite:setRotationSpeed(math.pi * -0.75)
      _class_0.__parent.__init(self, x, y, sprite)
      self.id = EntityTypes.goal
      self.goal_type = GoalTypes.attack
    end,
    __base = _base_0,
    __name = "AttackGoal",
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
  AttackGoal = _class_0
end
