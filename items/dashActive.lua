do
  local _parent_0 = ActiveItem
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self)
      self.rarity = self:getRandomRarity()
      local cd = ({
        5,
        4,
        3,
        2,
        1
      })[self.rarity]
      local sprite = Sprite("item/dashActive.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        local x, y = player.speed:getComponents()
        local sum = (math.abs(x)) + (math.abs(y))
        if sum > 0 then
          local speed = Vector(x, y, true)
          player.position:add(speed:multiply((Scale.diag * 350)))
          local radius = player:getHitBox().radius
          player.position.x = clamp(player.position.x, Screen_Size.border[1] + radius, Screen_Size.border[3] - radius)
          player.position.y = clamp(player.position.y, Screen_Size.border[2] + radius, (Screen_Size.border[4] + Screen_Size.border[2]) - radius)
        end
      end
      _parent_0.__init(self, sprite, cd, effect)
      self.name = "Insain Bolt"
      self.description = "Dash in the direction you are moving"
    end,
    __base = _base_0,
    __name = "DashActive",
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
  DashActive = _class_0
end
