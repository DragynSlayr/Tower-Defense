do
  local _class_0
  local _base_0 = {
    add = function(self, element)
      self.elements[#self.elements + 1] = element
    end,
    update = function(self, dt)
      for i = 1, #self.elements do
        self.elements[i]:update(dt)
      end
    end,
    draw = function(self)
      for i = 1, #self.elements do
        self.elements[i]:draw()
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.elements = { }
    end,
    __base = _base_0,
    __name = "UI"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  UI = _class_0
end
