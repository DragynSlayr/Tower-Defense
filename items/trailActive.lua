do
  local _parent_0 = ActiveItem
  local _base_0 = {
    getStats = function(self)
      local stats = _parent_0.getStats(self)
      table.insert(stats, "Trail Time: " .. self.effect_time .. "s")
      return stats
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self)
      self.rarity = self:getRandomRarity()
      local cd = ({
        30,
        25,
        20,
        15,
        10
      })[self.rarity]
      local sprite = Sprite("item/trailActive.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        sprite = Sprite("item/trailActive.tga", 32, 32, 1, 1.75)
        local trail = ParticleTrail(player.position.x, player.position.y, sprite, player)
        trail.life_time = self.effect_time
        trail.particle_type = ParticleTypes.enemy_poison
        self.trail = trail
        return Driver:addObject(self.trail, EntityTypes.particle)
      end
      _parent_0.__init(self, sprite, cd, effect)
      self.name = "Fire Trail"
      self.description = "A trail of fire follows the player"
      self.effect_time = ({
        7.5,
        7.75,
        8,
        8.25,
        8.5
      })[self.rarity]
      self.onEnd = function()
        return Driver:removeObject(self.trail, false)
      end
    end,
    __base = _base_0,
    __name = "TrailActive",
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
  TrailActive = _class_0
end
