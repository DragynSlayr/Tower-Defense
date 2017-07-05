do
  local _class_0
  local _parent_0 = BackgroundObject
  local _base_0 = {
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
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
        return self:kill()
      end
    end,
    applyPull = function(self, entity, dt)
      local x = self.position.x - entity.position.x
      local y = self.position.y - entity.position.y
      local veb = Vector(x, y)
      local ratio = map(veb:getLength(), 0, self.diag, 0, 10 * Scale.diag)
      local factor = 1 - (dt / ratio)
      factor = factor / (50 * Scale.diag)
      veb = veb:multiply(factor)
      return entity.position:add(veb)
    end,
    applyDamage = function(self, entity)
      local x = self.position.x - entity.position.x
      local y = self.position.y - entity.position.y
      local veb = Vector(x, y)
      local damage = 0
      local num = 0
      if Driver.objects[EntityTypes.player] then
        for k, p in pairs(Driver.objects[EntityTypes.player]) do
          damage = damage + p.damage
          num = num + 1
        end
      end
      damage = damage / num
      self.damage = map(veb:getLength(), 0, self.diag, 0, damage / 2)
      return entity:onCollide(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("background/blackhole.tga", 32, 32, 1, 1)
      _class_0.__parent.__init(self, x, y, sprite)
      self.life_time = 17
      self.diag = (Vector(Screen_Size.border[3], Screen_Size.border[4])):getLength()
    end,
    __base = _base_0,
    __name = "BlackHole",
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
  BlackHole = _class_0
end
