do
  local _parent_0 = PassiveItem
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self)
      self.rarity = self:getRandomRarity()
      local cd = ({
        0.5,
        0.4,
        0.3,
        0.2,
        0.1
      })[self.rarity]
      local sprite = Sprite("item/armorPassive.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        return player:setArmor(player.armor + (player.max_armor * 0.005), player.max_armor)
      end
      _parent_0.__init(self, sprite, cd, effect)
      self.name = "ArMORE"
      self.description = "Provides armor over time"
    end,
    __base = _base_0,
    __name = "ArmorPassive",
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
  ArmorPassive = _class_0
end
