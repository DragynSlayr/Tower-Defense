do
  local _parent_0 = PassiveItem
  local _base_0 = {
    unequip = function(self, player)
      _parent_0.unequip(self, player)
      player.max_health = player.max_health / self.amount
      player.health = player.max_health
      player.attack_range = player.attack_range / self.amount
      player.damage = player.damage / self.amount
      player.max_speed = player.max_speed / self.amount
      player.attack_speed = player.attack_speed / self.amount
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self)
      self.rarity = self:getRandomRarity()
      self.amount = ({
        1.3,
        1.35,
        1.4,
        1.45,
        1.5
      })[self.rarity]
      local sprite = Sprite("item/curryPassive.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        player.max_health = player.max_health * self.amount
        player.health = player.max_health
        player.attack_range = player.attack_range * self.amount
        player.damage = player.damage * self.amount
        player.max_speed = player.max_speed * self.amount
        player.attack_speed = player.attack_speed / self.amount
      end
      _parent_0.__init(self, sprite, nil, effect)
      self.name = "Hearty Curry"
      self.description = "Raises all player stats by " .. ((self.amount - 1) * 100) .. "%"
    end,
    __base = _base_0,
    __name = "CurryPassive",
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
  CurryPassive = _class_0
end
