do
  local _parent_0 = ActiveItem
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self)
      self.rarity = self:getRandomRarity()
      local cd = ({
        20,
        18,
        16,
        14,
        12
      })[self.rarity]
      local sprite = Sprite("background/blackhole.tga", 32, 32, 1, 1.75)
      sprite:setRotationSpeed(-math.pi / 2)
      local effect
      effect = function(self, player)
        local hole = BlackHole(player.position.x, player.position.y)
        return Driver:addObject(hole, EntityTypes.background)
      end
      _parent_0.__init(self, sprite, cd, effect)
      self.name = "Sucky thingy"
      self.description = "Places a black hole that sucks in enemies"
      self.effect_time = 7.5
    end,
    __base = _base_0,
    __name = "BlackHoleActive",
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
  BlackHoleActive = _class_0
end
