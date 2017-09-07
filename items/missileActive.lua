do
  local _class_0
  local _parent_0 = ActiveItem
  local _base_0 = {
    getStats = function(self)
      local stats = _class_0.__parent.__base.getStats(self)
      table.insert(stats, "Missiles: " .. self.num_missiles)
      return stats
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      self.rarity = self:getRandomRarity()
      local cd = ({
        15,
        14,
        13,
        12,
        11
      })[self.rarity]
      local sprite = Sprite("projectile/missile.tga", 32, 16, 1, 1.75)
      local effect
      effect = function(self, player)
        local angle = 2 * math.pi * (1 / self.num_missiles)
        local point = Vector(player:getHitBox().radius + (10 * Scale.diag), 0)
        for i = 1, self.num_missiles do
          local missile = Missile(player.position.x + point.x, player.position.y + point.y)
          Driver:addObject(missile, EntityTypes.bullet)
          point:rotate(angle)
        end
      end
      _class_0.__parent.__init(self, x, y, sprite, cd, effect)
      self.name = "Missile Barrage"
      self.description = "Launch a number of missiles"
      self.num_missiles = ({
        2,
        3,
        4,
        5,
        6
      })[self.rarity]
    end,
    __base = _base_0,
    __name = "MissileActive",
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
  MissileActive = _class_0
end
