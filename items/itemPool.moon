export class ItemPoolHandler
  new: =>
    @items = {
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
    @generatePool!

  generatePool: =>
      items = {}
      for k, item in pairs @items
        for i = 1, item.probability
          table.insert items, item
      @items = items
      shuffle @items

  getItem: =>
    return TurretSlagPassive 0, 0
    --item = pick @items
    --return item 0, 0
