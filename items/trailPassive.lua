do
  local _class_0
  local _parent_0 = PassiveItem
  local _base_0 = {
    getStats = function(self)
      local stats = _class_0.__parent.__base.getStats(self)
      table.insert(stats, "Length: " .. self.life_time)
      return stats
    end,
    unequip = function(self, player)
      _class_0.__parent.__base.unequip(self, player)
      player.trail = self.old_trail
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      self.rarity = self:getRandomRarity()
      self.life_time = ({
        1.5,
        1.75,
        2,
        2.25,
        2.5
      })[self.rarity]
      local sprite = Sprite("item/trailPassive.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        sprite = Sprite("item/trailPassive.tga", 32, 32, 1, 1.75)
        local trail = ParticleTrail(player.position.x, player.position.y, sprite, player)
        trail.life_time = self.life_time
        trail.particle_type = ParticleTypes.enemy_poison
        self.old_trail = player.trail
        player.trail = trail
      end
      _class_0.__parent.__init(self, x, y, sprite, nil, effect)
      self.name = "Poison Trail"
      self.description = "A trail of poison follows the player"
    end,
    __base = _base_0,
    __name = "TrailPassive",
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
  TrailPassive = _class_0
end
