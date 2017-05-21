do
  local _class_0
  local _base_0 = {
    get = function(self)
      return self.r, self.g, self.b, self.a
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, r, g, b, a)
      if r == nil then
        r = 0
      end
      if g == nil then
        g = 0
      end
      if b == nil then
        b = 0
      end
      if a == nil then
        a = 255
      end
      self.r = r
      self.g = g
      self.b = b
      self.a = a
    end,
    __base = _base_0,
    __name = "Color"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Color = _class_0
end
