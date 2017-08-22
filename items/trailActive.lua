do
  local _class_0
  local _parent_0 = ActiveItem
  local _base_0 = {
    getStats = function(self)
      local stats = _class_0.__parent.__base.getStats(self)
      table.insert(stats, "Trail Time: " .. self.effect_time .. "s")
      return stats
    end,
    update2 = function(self, dt)
      _class_0.__parent.__base.update2(self, dt)
      if self.used then
        self.effect_timer = self.effect_timer + dt
        if self.effect_timer >= self.effect_time then
          self.effect_timer = 0
          self.used = false
          self.player.trail = self.old_trail
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
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
        self.old_trail = player.trail
        player.trail = trail
        self.used = true
      end
      _class_0.__parent.__init(self, x, y, sprite, cd, effect)
      self.name = "Fire Trail"
      self.description = "A trail of fire follows the player"
      self.used = false
      self.effect_time = ({
        7.5,
        7.75,
        8,
        8.25,
        8.5
      })[self.rarity]
      self.effect_timer = 0
    end,
    __base = _base_0,
    __name = "TrailActive",
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
  TrailActive = _class_0
end
