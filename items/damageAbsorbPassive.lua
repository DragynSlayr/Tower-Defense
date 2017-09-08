do
  local _class_0
  local _parent_0 = PassiveItem
  local _base_0 = {
    getStats = function(self)
      local stats = _class_0.__parent.__base.getStats(self)
      table.insert(stats, "Absorb Chance: " .. self.chance .. "%")
      return stats
    end,
    pickup = function(self, player)
      _class_0.__parent.__base.pickup(self, player)
      self.last_health = player.health
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      self.rarity = self:getRandomRarity()
      self.chance = ({
        5,
        7.5,
        10,
        12.5,
        15
      })[self.rarity]
      local sprite = Sprite("item/damageAbsorbPassive.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        local health = player.health
        if health < self.last_health then
          local difference = self.last_health - health
          self.last_health = health
          if math.random() >= ((100 - self.chance) / 100) then
            player.health = player.health + difference
          end
        end
      end
      _class_0.__parent.__init(self, x, y, sprite, 0, effect)
      self.name = "Damage Absorb"
      self.description = "Has a chance to absorb incoming damage"
    end,
    __base = _base_0,
    __name = "DamageAbsorbPassive",
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
  DamageAbsorbPassive = _class_0
end
