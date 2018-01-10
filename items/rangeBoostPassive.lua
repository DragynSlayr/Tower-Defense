do
  local _class_0
  local _parent_0 = PassiveItem
  local _base_0 = {
    unequip = function(self, player)
      _class_0.__parent.__base.unequip(self, player)
      player.attack_range = player.attack_range / self.amount
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      self.rarity = self:getRandomRarity()
      self.amount = ({
        1.2,
        1.25,
        1.3,
        1.35,
        1.4
      })[self.rarity]
      local sprite = Sprite("item/rangeBoost.tga", 24, 24, 1, 56 / 24)
      local effect
      effect = function(self, player)
        player.attack_range = player.attack_range * self.amount
      end
      _class_0.__parent.__init(self, sprite, nil, effect)
      self.name = "Range Up"
      self.description = "Raises player range by " .. ((self.amount - 1) * 100) .. "%"
    end,
    __base = _base_0,
    __name = "RangeBoostPassive",
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
  RangeBoostPassive = _class_0
end
