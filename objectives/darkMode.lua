do
  local _parent_0 = Mode
  local _base_0 = {
    nextWave = function(self)
      _parent_0.nextWave(self)
      self.wave = DarkWave(self)
    end,
    finish = function(self)
      if Driver.objects[EntityTypes.player] then
        for k, p in pairs(Driver.objects[EntityTypes.player]) do
          p.hit = p.health < p.max_health * 0.75
        end
      end
      return _parent_0.finish(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, parent)
      _parent_0.__init(self, parent)
      self.objective_text = "Find the locked hearts"
      self.mode_type = ModeTypes.dark
    end,
    __base = _base_0,
    __name = "DarkMode",
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
  DarkMode = _class_0
end
