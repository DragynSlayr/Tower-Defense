do
  local _class_0
  local _base_0 = {
    generatePool = function(self)
      local items = { }
      for k, item in pairs(self.items) do
        for i = 1, item.probability do
          table.insert(items, item)
        end
      end
      self.items = items
      return shuffle(self.items)
    end,
    getItem = function(self)
      return TurretSlagPassive(0, 0)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.items = {
        BombActive,
        TrailActive,
        ShieldActive,
        BlackHoleActive,
        DamageBoostActive,
        FreezeFieldActive,
        PoisonFieldActive,
        HealingFieldActive,
        BombPassive,
        ArmorPassive,
        TrailPassive,
        ExtraLifePassive,
        DoubleShotPassive,
        RangeBoostPassive,
        SpeedBoostPassive,
        TurretSlagPassive,
        DamageBoostPassive,
        HealthBoostPassive,
        DamageAbsorbPassive,
        MovingTurretPassive,
        DamageReflectPassive,
        NullItem
      }
      return self:generatePool()
    end,
    __base = _base_0,
    __name = "ItemPoolHandler"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ItemPoolHandler = _class_0
end
