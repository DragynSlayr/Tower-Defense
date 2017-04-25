do
  local _class_0
  local _base_0 = {
    contains = function(self, point)
      local x = point.x - self.center.x
      local y = point.y - self.center.y
      local distance = (x * x) + (y * y)
      local colliding = distance <= (self.radius * self.radius)
      local collision_distance = distance - (self.radius * self.radius)
      return colliding, collision_distance
    end,
    getCollisionDistance = function(self, point)
      local colliding, collision_distance = self:contains(point)
      if colliding then
        return -collision_distance
      else
        return 0
      end
    end,
    getCenter = function(self)
      return self.center
    end,
    setCenter = function(self, point)
      self.center = point
    end,
    getRadius = function(self)
      return self.radius
    end,
    setRadius = function(self, radius)
      self.radius = radius
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, radius)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      if radius == nil then
        radius = 1
      end
      self.center = Point(x, y)
      self.radius = radius
    end,
    __base = _base_0,
    __name = "Circle"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Circle = _class_0
end
