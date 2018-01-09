do
  local _parent_0 = PassiveItem
  local _base_0 = {
    getStats = function(self)
      local stats = _parent_0.getStats(self)
      table.insert(stats, "Reflect Chance: " .. self.chance .. "%")
      return stats
    end,
    pickup = function(self, player)
      _parent_0.pickup(self, player)
      self.last_health = player.health
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self)
      self.rarity = self:getRandomRarity()
      self.chance = ({
        50,
        55,
        60,
        65,
        70
      })[self.rarity]
      local sprite = Sprite("item/damageReflectPassive.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        local health = player.health
        if health < self.last_health then
          local difference = self.last_health - health
          self.last_health = health
          if math.random() >= ((100 - self.chance) / 100) then
            local filters = {
              EntityTypes.enemy,
              EntityTypes.boss
            }
            for k2, typeof in pairs(filters) do
              if Driver.objects[typeof] then
                for k, e in pairs(Driver.objects[typeof]) do
                  local enemy = e:getHitBox()
                  local p = player:getHitBox()
                  p.radius = p.radius + (player.attack_range + player.range_boost)
                  if p:contains(enemy) then
                    local temp_damage = player.damage
                    player.damage = difference
                    e:onCollide(player)
                    player.damage = temp_damage
                  end
                end
              end
            end
          end
        end
      end
      _parent_0.__init(self, sprite, 0, effect)
      self.name = "Vary Parry"
      self.description = "Has a chance to reflect damage taken"
    end,
    __base = _base_0,
    __name = "DamageReflectPassive",
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
  DamageReflectPassive = _class_0
end
