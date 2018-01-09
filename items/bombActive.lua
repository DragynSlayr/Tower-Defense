do
  local _parent_0 = ActiveItem
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self)
      self.rarity = self:getRandomRarity()
      local cd = ({
        15,
        12.5,
        10,
        7.5,
        5
      })[self.rarity]
      local sprite = Sprite("background/bomb.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        local bomb = Bomb(player.position.x, player.position.y)
        return Driver:addObject(bomb, EntityTypes.background)
      end
      _parent_0.__init(self, sprite, cd, effect)
      self.name = "Kaboom"
      self.description = "Places a powerful bomb"
      self.effect_time = 3
    end,
    __base = _base_0,
    __name = "BombActive",
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
  BombActive = _class_0
end
