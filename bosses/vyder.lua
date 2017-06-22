do
  local _class_0
  local _parent_0 = Boss
  local _base_0 = {
    getHitBox = function(self)
      local radius = math.min(self.sprite.scaled_height / 2, self.sprite.scaled_width / 2)
      radius = radius * 0.75
      return Circle(self.position.x, self.position.y + (25 * Scale.height), radius)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("boss/fox_bat/fox_bat.tga", 729, 960, 1, 1)
      sprite:setScale(0.25, 0.25)
      _class_0.__parent.__init(self, x, y, sprite)
      self.bossType = BossTypes.vyder
      self.health = 300
      self.max_health = self.health
    end,
    __base = _base_0,
    __name = "BossVyder",
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
  BossVyder = _class_0
end
