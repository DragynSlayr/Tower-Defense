do
  local _class_0
  local _parent_0 = PassiveItem
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("item/turretSlagPassive.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        for k, t in pairs(player.turret) do
          if t.target then
            local bullet = Bullet(t.position.x, t.position.y - t.sprite.scaled_height / 2 + 10, t.target, 0)
            bullet.sprite = Sprite("projectile/slag.tga", 32, 32, 1, 0.75)
            bullet.slagging = true
            Driver:addObject(bullet, EntityTypes.bullet)
          end
        end
      end
      _class_0.__parent.__init(self, x, y, sprite, 1, effect)
      self.name = "Slag Shot"
      self.description = "Turret shoots slagging shots"
    end,
    __base = _base_0,
    __name = "TurretSlagPassive",
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
  TurretSlagPassive = _class_0
end
