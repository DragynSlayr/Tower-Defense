do
  local _class_0
  local _parent_0 = ActiveItem
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("item/dashActive.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        x, y = player.speed:getComponents()
        local speed = Vector(x, y, true)
        player.position:add(speed:multiply((Scale.diag * 350)))
        local radius = player:getHitBox().radius
        player.position.x = clamp(player.position.x, Screen_Size.border[1] + radius, Screen_Size.border[3] - radius)
        player.position.y = clamp(player.position.y, Screen_Size.border[2] + radius, (Screen_Size.border[4] + Screen_Size.border[2]) - radius)
      end
      _class_0.__parent.__init(self, x, y, sprite, 5, effect)
      self.name = "Dash"
      self.description = "Dash in the direction you are moving"
    end,
    __base = _base_0,
    __name = "DashActive",
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
  DashActive = _class_0
end
