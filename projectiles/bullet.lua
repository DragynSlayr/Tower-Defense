do
  local _parent_0 = HomingProjectile
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, x, y, target, damage)
      local sprite = Sprite("projectile/bullet_anim.tga", 32, 16, 0.02, 0.75)
      _parent_0.__init(self, x, y, target, sprite)
      self.damage = damage
      local sound = Sound("turret_bullet.ogg", 0.005, false, 0.75, true)
      self.death_sound = MusicPlayer:add(sound)
    end,
    __base = _base_0,
    __name = "Bullet",
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
  Bullet = _class_0
end
