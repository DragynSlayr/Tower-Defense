do
  local _class_0
  local _parent_0 = HomingProjectile
  local _base_0 = {
    kill = function(self)
      _class_0.__parent.__base.kill(self)
      if Upgrade.player_special[1] then
        if Driver.objects[EntityTypes.player] then
          for k, p in pairs(Driver.objects[EntityTypes.player]) do
            p.health = p.health + (1 / 600)
            p.health = math.min(p.health, p.max_health)
          end
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, target, damage)
      _class_0.__parent.__init(self, x, y, target)
      self.sprite = Sprite("enemy/bullet.tga", 26, 20, 1, 0.5)
      self.damage = damage
    end,
    __base = _base_0,
    __name = "PlayerBullet",
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
  PlayerBullet = _class_0
end
