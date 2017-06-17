do
  local _class_0
  local _parent_0 = Mode
  local _base_0 = {
    nextWave = function(self)
      _class_0.__parent.__base.nextWave(self)
      self.wave = CaptureWave(self)
    end,
    finish = function(self)
      _class_0.__parent.__base.finish(self)
      if Driver.objects[EntityTypes.goal] then
        for k, o in pairs(Driver.objects[EntityTypes.goal]) do
          Driver:removeObject(o, false)
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      _class_0.__parent.__init(self, parent)
      self.objective_text = "Capture the objective"
      self.mode_type = ModeTypes.capture
    end,
    __base = _base_0,
    __name = "CaptureMode",
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
  CaptureMode = _class_0
end
