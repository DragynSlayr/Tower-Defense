do
  local _parent_0 = BackgroundObject
  local _base_0 = {
    kill = function(self)
      _parent_0.kill(self)
      if Driver.objects[EntityTypes.enemy] then
        for k, e in pairs(Driver.objects[EntityTypes.enemy]) do
          e.speed_override = false
        end
      end
      if Driver.objects[EntityTypes.boss] then
        for k, b in pairs(Driver.objects[EntityTypes.boss]) do
          b.speed_override = false
        end
      end
    end,
    update = function(self, dt)
      _parent_0.update(self, dt)
      if Driver.objects[EntityTypes.enemy] then
        for k, e in pairs(Driver.objects[EntityTypes.enemy]) do
          self:applyPull(e, dt)
          self:applyDamage(e)
        end
      end
      if Driver.objects[EntityTypes.boss] then
        for k, b in pairs(Driver.objects[EntityTypes.boss]) do
          self:applyPull(b, dt)
          self:applyDamage(b)
        end
      end
      self.life_time = self.life_time - dt
      if self.life_time <= 0 then
        self.health = 0
      end
    end,
    applyPull = function(self, entity, dt)
      local x = self.position.x - entity.position.x
      local y = self.position.y - entity.position.y
      local vec = Vector(x, y)
      local ratio = vec:getLength() / self.diag
      ratio = map(ratio, 0, 1, 1, 0)
      return entity:setSpeedOverride(vec, ratio)
    end,
    applyDamage = function(self, entity)
      local x = self.position.x - entity.position.x
      local y = self.position.y - entity.position.y
      local vec = Vector(x, y)
      local damage = 0
      local num = 0
      if Driver.objects[EntityTypes.player] then
        for k, p in pairs(Driver.objects[EntityTypes.player]) do
          damage = damage + p.damage
          num = num + 1
        end
      end
      damage = damage / num
      local ratio = vec:getLength() / self.diag
      ratio = ratio * 300
      self.damage = (1 / ratio) * damage
      return entity:onCollide(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("background/blackhole.tga", 32, 32, 1, 1.25)
      _parent_0.__init(self, x, y, sprite)
      self.life_time = 7.5
      self.diag = (Vector(Screen_Size.border[3], Screen_Size.border[4])):getLength()
      return self.sprite:setRotationSpeed(-math.pi / 2)
    end,
    __base = _base_0,
    __name = "BlackHole",
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
  BlackHole = _class_0
end
