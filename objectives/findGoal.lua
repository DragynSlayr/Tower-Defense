do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      if self.trail then
        local x = self.position.x - self.trail.position.x
        local y = self.position.y - self.trail.position.y
        local speed = Vector(x, y, true)
        speed = speed:multiply((dt * self.movement_speed))
        self.trail.position:add(speed)
        self.trail:setVelocity(self.velocity:multiply(0.4))
        self.velocity:rotate(self.angle)
        return self.trail:update(dt)
      end
    end,
    draw = function(self)
      if self.trail then
        self.trail:draw()
      end
      return _class_0.__parent.__base.draw(self)
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
      local sprite = Sprite("objective/lockedHeart.tga", 26, 26, 1, 2)
      _class_0.__parent.__init(self, x, y, sprite)
      self.id = EntityTypes.goal
      self.goal_type = GoalTypes.find
      self.draw_health = false
      self.trail = nil
      self.movement_speed = 250
      self.velocity = getRandomUnitStart()
      self.angle = 2 * math.pi * (1 / 30)
      self.item_drop_chance = 0.2
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
