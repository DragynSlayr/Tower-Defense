do
  local _base_0 = {
    rotate = function(self, angle)
      local vec = Vector(self.x, self.y)
      vec:rotate(angle)
      self.x, self.y = vec:getComponents()
    end,
    getComponents = function(self)
      return self.x, self.y
    end,
    __tostring = function(self)
      return "(" .. self.x .. ", " .. self.y .. ")"
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, x, y)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      self.x = x
      self.y = y
    end,
    __base = _base_0,
    __name = "Point"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Point = _class_0
end
