do
  local _class_0
  local _parent_0 = BackgroundObject
  local _base_0 = {
    onCollide = function(self, object)
      self.health = 0
    end,
    update = function(self, dt)
      self.change_timer = self.change_timer + dt
      if self.change_timer >= self.change_time then
        self.change_timer = 0
        self.speed = getRandomUnitStart(self.speed_multiplier)
      end
      return _class_0.__parent.__base.update(self, dt)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("maps/block.tga", 32, 32, 1, 0.5)
      _class_0.__parent.__init(self, x, y, sprite)
      self.sprite:setColor({
        0,
        0,
        0,
        0
      })
      self.change_time = 0.25
      self.change_timer = 0
      self.speed = Vector(0, 0)
      self.speed_multiplier = 200
    end,
    __base = _base_0,
    __name = "Jitter",
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
  Jitter = _class_0
end
