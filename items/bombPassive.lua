do
  local _class_0
  local _parent_0 = PassiveItem
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      self.rarity = self:getRandomRarity()
      local cd = ({
        7,
        6,
        5,
        4,
        3
      })[self.rarity]
      local sprite = Sprite("item/bomb.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        local x = math.random(Screen_Size.border[1], Screen_Size.border[3])
        local y = math.random(Screen_Size.border[2], Screen_Size.border[4])
        local bomb = Bomb(x, y)
        return Driver:addObject(bomb, EntityTypes.background)
      end
      _class_0.__parent.__init(self, sprite, cd, effect)
      self.name = "Tele-frag"
      self.description = "A bomb randomly spawns on the screen"
    end,
    __base = _base_0,
    __name = "BombPassive",
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
  BombPassive = _class_0
end
