do
  local _class_0
  local _parent_0 = ActiveItem
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      self.rarity = self:getRandomRarity()
      local cd = ({
        15,
        14,
        13,
        12,
        11
      })[self.rarity]
      local sprite = Sprite("background/healingField.tga", 32, 32, 2, 1.75)
      local effect
      effect = function(self, player)
        local field = HealingField(player.position.x, player.position.y)
        return Driver:addObject(field, EntityTypes.background)
      end
      _class_0.__parent.__init(self, sprite, cd, effect)
      self.name = "Healing Field"
      self.description = "Place a healing field"
      self.effect_time = 6.5
    end,
    __base = _base_0,
    __name = "HealingFieldActive",
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
  HealingFieldActive = _class_0
end
