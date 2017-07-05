do
  local _class_0
  local _parent_0 = Item
  local _base_0 = {
    pickup = function(self, player)
      _class_0.__parent.__base.pickup(self, player)
      if self.delay == -1 then
        return self:effect(self.player)
      end
    end,
    update2 = function(self, dt)
      _class_0.__parent.__base.update2(self, dt)
      if self.delay ~= -1 and self.timer >= self.delay then
        self.timer = 0
        return self:effect(self.player)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, sprite, delay, effect)
      if delay == nil then
        delay = -1
      end
      _class_0.__parent.__init(self, x, y, sprite)
      self.item_type = ItemTypes.passive
      self.effect = effect
      self.delay = delay
    end,
    __base = _base_0,
    __name = "PassiveItem",
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
  PassiveItem = _class_0
end
