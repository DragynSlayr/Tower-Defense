do
  local _class_0
  local _parent_0 = BackgroundObject
  local _base_0 = {
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      self.timer = self.timer + dt
      if self.timer >= self.heal_delay then
        self.timer = 0
        if Driver.objects[EntityTypes.player] then
          for k, p in pairs(Driver.objects[EntityTypes.player]) do
            local target = p:getHitBox()
            local healer = self:getHitBox()
            if target:contains(healer) then
              p.health = clamp(p.health + self.healing_amount, 0, p.max_health)
            end
          end
        end
        if Driver.objects[EntityTypes.turret] then
          for k, t in pairs(Driver.objects[EntityTypes.turret]) do
            local target = t:getAttackHitBox()
            local healer = self:getHitBox()
            if target:contains(healer) then
              t.health = clamp(t.health + self.healing_amount, 0, t.max_health)
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
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("background/healingField.tga", 32, 32, 2, 4)
      _class_0.__parent.__init(self, x, y, sprite)
      self.life_time = 6.5
      self.timer = 0
      self.heal_delay = 0.5
      self.healing_amount = 1 / 4
    end,
    __base = _base_0,
    __name = "HealingField",
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
  HealingField = _class_0
end
