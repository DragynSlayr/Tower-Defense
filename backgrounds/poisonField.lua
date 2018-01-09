do
  local _parent_0 = BackgroundObject
  local _base_0 = {
    update = function(self, dt)
      _parent_0.update(self, dt)
      self.timer = self.timer + dt
      if self.timer >= self.poison_delay then
        self.timer = 0
        if Driver.objects[EntityTypes.enemy] then
          for k, e in pairs(Driver.objects[EntityTypes.enemy]) do
            local target = e:getHitBox()
            local poison = self:getHitBox()
            if target:contains(poison) then
              e.health = clamp(e.health - self.poison_amount, 0, e.max_health)
            end
          end
        end
        if Driver.objects[EntityTypes.boss] then
          for k, b in pairs(Driver.objects[EntityTypes.boss]) do
            local target = b:getHitBox()
            local poison = self:getHitBox()
            if target:contains(poison) then
              b.health = clamp(b.health - self.poison_amount, 0, b.max_health)
            end
          end
        end
      end
      self.life_time = self.life_time - dt
      if self.life_time <= 0 then
        self.health = 0
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("background/poisonField.tga", 32, 32, 2, 8)
      sprite.color[4] = 200
      _parent_0.__init(self, x, y, sprite)
      self.life_time = 7.5
      self.timer = 0
      self.poison_delay = 0.1
      self.poison_amount = 0.5
    end,
    __base = _base_0,
    __name = "PoisonField",
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
  PoisonField = _class_0
end
