do
  local _parent_0 = Wave
  local _base_0 = {
    start = function(self)
      for i = 1, 2 do
        local x = math.random(Screen_Size.border[1], Screen_Size.border[3] + Screen_Size.border[1])
        local y = math.random(Screen_Size.border[2], Screen_Size.border[4] + Screen_Size.border[2])
        Driver:addObject((CloudEnemy(x, y)), EntityTypes.enemy)
      end
    end,
    update = function(self, dt)
      return _parent_0.update(self, dt)
    end,
    draw = function(self)
      return _parent_0.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, parent)
      return _parent_0.__init(self, parent)
    end,
    __base = _base_0,
    __name = "TestWave",
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
  TestWave = _class_0
end
