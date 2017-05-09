do
  local _class_0
  local _parent_0 = Enemy
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("enemy/bullet.tga", 26, 20, 1, 2)
      _class_0.__parent.__init(self, x, y, sprite)
      self.damage = 2
      self.health = 8
      self.max_health = self.health
      self.max_speed = 100
      self.speed_multiplier = 100
      self.enemyType = EnemyTypes.strong
      self.score_value = 200
    end,
    __base = _base_0,
    __name = "StrongEnemy",
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
  StrongEnemy = _class_0
end
