do
  local _parent_0 = HomingProjectile
  local _base_0 = {
    kill = function(self)
      _parent_0.kill(self)
      if Upgrade.player_special[1] then
        if Driver.objects[EntityTypes.player] then
          for k, p in pairs(Driver.objects[EntityTypes.player]) do
            p.health = p.health + (Stats.player[3] * 0.01)
            p.health = math.min(p.health, p.max_health)
          end
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, x, y, target, damage)
      local sprite = Sprite("enemy/bullet.tga", 26, 20, 1, 0.5)
      _parent_0.__init(self, x, y, target, sprite)
      self.damage = damage
      self.trail = nil
      local sound = Sound("player_bullet.ogg", 0.025, false, 1.125, true)
      self.death_sound = MusicPlayer:add(sound)
    end,
    __base = _base_0,
    __name = "PlayerBullet",
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
  PlayerBullet = _class_0
end
