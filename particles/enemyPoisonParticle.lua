do
  local _class_0
  local _parent_0 = Particle
  local _base_0 = {
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      if self.alive then
        if Driver.objects[EntityTypes.enemy] then
          for k, v in pairs(Driver.objects[EntityTypes.enemy]) do
            local other = v:getHitBox()
            local this = self:getHitBox()
            if other:contains(this) then
              v:onCollide(self)
            end
          end
        end
        if Driver.objects[EntityTypes.boss] then
          for k, v in pairs(Driver.objects[EntityTypes.boss]) do
            local other = v:getHitBox()
            local this = self:getHitBox()
            if other:contains(this) then
              v:onCollide(self)
            end
          end
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, sprite, alpha_start, alpha_end, life_time)
      _class_0.__parent.__init(self, x, y, sprite, alpha_start, alpha_end, life_time)
      self.damage = 0.01
    end,
    __base = _base_0,
    __name = "EnemyPoisonParticle",
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
  EnemyPoisonParticle = _class_0
end
