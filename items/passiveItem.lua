do
  local _parent_0 = Item
  local _base_0 = {
    getStats = function(self)
      local stats = _parent_0.getStats(self)
      if self.delay > 0 then
        local s = string.format("Frequency: %.2fs", self.delay)
        table.insert(stats, s)
      end
      return stats
    end,
    pickup = function(self, player)
      _parent_0.pickup(self, player)
      if self.delay == -1 then
        return self:effect(self.player)
      end
    end,
    update2 = function(self, dt)
      _parent_0.update2(self, dt)
      if self.delay ~= -1 and self.timer >= self.delay then
        self.timer = 0
        return self:effect(self.player)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, sprite, delay, effect)
      if delay == nil then
        delay = -1
      end
      _parent_0.__init(self, sprite)
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
  PassiveItem = _class_0
end
