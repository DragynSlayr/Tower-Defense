do
  local _class_0
  local _parent_0 = Boss
  local _base_0 = {
    getHitBox = function(self)
      local radius = math.min(self.sprite.scaled_height / 2, self.sprite.scaled_width / 2)
      radius = radius * 0.75
      return Circle(self.position.x, self.position.y + (25 * Scale.height), radius)
    end,
    update = function(self, dt)
      self.speed = Vector(self.target_position.x - self.position.x, self.target_position.y - self.position.y)
      local dist = self.speed:getLength()
      self.speed:toUnitVector()
      self.speed = self.speed:multiply(self.speed_multiplier)
      _class_0.__parent.__base.update(self, dt)
      if dist <= self:getHitBox().radius then
        self.target_position = Driver:getRandomPosition()
      end
    end,
    draw = function(self)
      _class_0.__parent.__base.draw(self)
      love.graphics.push("all")
      love.graphics.setShader(Driver.shader)
      love.graphics.setColor(255, 0, 0, 255)
      love.graphics.circle("fill", self.target_position.x, self.target_position.y, 3, 360)
      love.graphics.setShader()
      return love.graphics.pop()
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
      self.speed_multiplier = 200
      sprite = Sprite("poison.tga", 64, 64, 1, 2)
      self.trail = ParticleTrail(self.position.x, self.position.y, sprite, self)
      self.trail.life_time = 3
      self.ai = { }
      self.ai.phase = 1
      self.target_position = Driver:getRandomPosition()
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
