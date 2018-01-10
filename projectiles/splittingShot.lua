do
  local _class_0
  local _parent_0 = LinearProjectile
  local _base_0 = {
    kill = function(self)
      _class_0.__parent.__base.kill(self)
      self.target:onCollide(self)
      if self.depth < self.max_depth then
        local target = self.target:getHitBox()
        local bullet = self:getHitBox()
        bullet.radius = bullet.radius + self.attack_range
        if target:contains(bullet) then
          local speeds = {
            {
              0,
              1
            },
            {
              1,
              0
            },
            {
              -1,
              0
            },
            {
              0,
              -1
            },
            {
              1,
              1
            },
            {
              -1,
              -1
            },
            {
              -1,
              1
            },
            {
              1,
              -1
            }
          }
          for k, speed in pairs(speeds) do
            local copy = self.sprite:getCopy()
            copy:scaleUniformly(0.75)
            local b = SplitShot(self.position.x, self.position.y, (Vector(speed[1], speed[2])), self.dist * 0.75, copy)
            b.depth = self.depth + 1
            b.speed_multiplier = self.speed_multiplier * 1.5
            b.damage = self.damage / 2
            Driver:addObject(b, EntityTypes.bullet)
          end
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, speed, dist, sprite)
      _class_0.__parent.__init(self, x, y, speed, dist, sprite)
      self.depth = 1
      self.max_depth = 2
      self.dist = dist
      self.block_rotation = false
      self.target = Jitter(self.target.position.x, self.target.position.y)
      return Driver:addObject(self.target, EntityTypes.background)
    end,
    __base = _base_0,
    __name = "SplitShot",
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
  SplitShot = _class_0
end
