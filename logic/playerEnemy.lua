do
  local _class_0
  local _parent_0 = Enemy
  local _base_0 = {
    findNearestTarget = function(self)
      local closest = nil
      local closest_distance = math.max(love.graphics.getWidth() * 2, love.graphics.getHeight() * 2)
      if Driver.objects[EntityTypes.player] then
        for k, v in pairs(Driver.objects[EntityTypes.player]) do
          local player = v:getHitBox()
          local enemy = self:getHitBox()
          local dist = Vector(enemy.center.x - player.center.x, enemy.center.y - player.center.y)
          if dist:getLength() < closest_distance then
            closest_distance = dist:getLength()
            closest = v
          end
        end
      end
      self.target = closest
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("enemy/enemy.tga", 26, 26, 1, 0.75)
      _class_0.__parent.__init(self, x, y, sprite)
      self.damage = 0.5
      self.max_speed = 350
      self.speed_multiplier = 350
    end,
    __base = _base_0,
    __name = "PlayerEnemy",
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
  PlayerEnemy = _class_0
end
