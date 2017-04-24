do
  local _class_0
  local _base_0 = {
    getLength = function(self)
      return math.sqrt((self.x * self.x) + (self.y * self.y))
    end,
    toUnitVector = function(self)
      local length = self:getLength()
      self.x = self.x / length
      self.y = self.y / length
    end,
    getAngleBetween = function(self, vec)
      local angle = math.atan2(self.y - vec.y, self.x - vec.x)
      return angle + (math.pi / 2)
    end,
    getDistanceBetween = function(self, vec)
      local newVec = Vector(self.x - vec.x, self.y - vec.y)
      return newVec:getLength()
    end,
    rotate = function(self, angle)
      local cos_angle, sin_angle = self:getCosSin(angle)
      local x = (cos_angle * self.x) - (sin_angle * self.y)
      local y = (sin_angle * self.x) + (cos_angle * self.y)
      self.x = x
      self.y = y
    end,
    getCosSin = function(self, angle)
      local cos_angle = math.cos(angle)
      local sin_angle = math.sqrt(1 - (cos_angle * cos_angle))
      cos_angle = math.sqrt(1 - (sin_angle * sin_angle))
      return cos_angle, sin_angle
    end,
    add = function(self, vec)
      self.x = self.x + vec.x
      self.y = self.y + vec.y
    end,
    multiply = function(self, factor)
      return Vector(self.x * factor, self.y * factor)
    end,
    getComponents = function(self)
      return self.x, self.y
    end,
    __tostring = function(self)
      return "(" .. self.x .. ", " .. self.y .. ")"
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, isUnit)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      if isUnit == nil then
        isUnit = false
      end
      self.x = x
      self.y = y
      if isUnit then
        return self:toUnitVector()
      end
    end,
    __base = _base_0,
    __name = "Vector"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Vector = _class_0
end
