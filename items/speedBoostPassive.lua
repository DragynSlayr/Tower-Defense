do
  local _parent_0 = PassiveItem
  local _base_0 = {
    unequip = function(self, player)
      _parent_0.unequip(self, player)
      player.max_speed = player.max_speed / self.amount
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self)
      self.rarity = self:getRandomRarity()
      self.amount = ({
        1.2,
        1.25,
        1.3,
        1.35,
        1.4
      })[self.rarity]
      local sprite = Sprite("item/speedBoost.tga", 24, 24, 1, 56 / 24)
      local effect
      effect = function(self, player)
        player.max_speed = player.max_speed * self.amount
      end
      _parent_0.__init(self, sprite, nil, effect)
      self.name = "Speed Up"
      self.description = "Raises player speed by " .. ((self.amount - 1) * 100) .. "%"
    end,
    __base = _base_0,
    __name = "SpeedBoostPassive",
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
  SpeedBoostPassive = _class_0
end
