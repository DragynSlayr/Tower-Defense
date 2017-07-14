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
      TrailPassive,
      ExtraLifePassive,
      RangeBoostPassive,
      SpeedBoostPassive,
      DamageBoostPassive,
      HealthBoostPassive,
      MovingTurretPassive,
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
    item = pick @items
    return item 0, 0
