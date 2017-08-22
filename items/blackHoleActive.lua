do
  local _class_0
  local _parent_0 = ActiveItem
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      self.rarity = self:getRandomRarity()
      local cd = ({
        20,
        18,
        16,
        14,
        12
      })[self.rarity]
      local sprite = Sprite("background/blackhole.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        local hole = BlackHole(player.position.x, player.position.y)
        return Driver:addObject(hole, EntityTypes.background)
      end
      _class_0.__parent.__init(self, x, y, sprite, cd, effect)
      self.name = "Singularity"
      self.description = "Places a black hole that sucks in enemies"
    end,
    __base = _base_0,
    __name = "BlackHoleActive",
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
  BlackHoleActive = _class_0
end
