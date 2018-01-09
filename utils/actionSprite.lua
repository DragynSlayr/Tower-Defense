do
  local _parent_0 = Sprite
  local _base_0 = {
    finish = function(self)
      self.parent.sprite = self.parent.normal_sprite
      return self:action()
    end,
    update = function(self, dt)
      local start = self.current_frame
      _parent_0.update(self, dt)
      if start > self.current_frame then
        return self:finish()
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, name, height, width, delay, scale, parent, action)
      _parent_0.__init(self, name, height, width, delay, scale)
      self.parent = parent
      self.action = action
    end,
    __base = _base_0,
    __name = "ActionSprite",
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
  ActionSprite = _class_0
end
