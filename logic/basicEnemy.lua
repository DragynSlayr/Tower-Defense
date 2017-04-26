do
  local _class_0
  local _parent_0 = Enemy
  local _base_0 = {
    kill = function(self)
      _class_0.__parent.kill(self)
      for i = 1, 2 do
        local x = math.random(love.graphics.getWidth())
        local y = math.random(love.graphics.getHeight())
        local enemy = BasicEnemy(x, y)
        Driver:addObject(enemy, EntityTypes.enemy)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("enemy/tracker.tga", 25, 25, 1, 2)
      return _class_0.__parent.__init(self, x, y, sprite, Player)
    end,
    __base = _base_0,
    __name = "BasicEnemy",
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
  BasicEnemy = _class_0
end
