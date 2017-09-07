export class ItemPoolHandler
  new: =>
    @items = {
      EMPActive,
      BombActive,
      DashActive,
      CloneActive,
      TrailActive,
      ShieldActive,
      DeadEyeActive,
      MissileActive,
      WholeHogActive,
      BlackHoleActive,
      MoltenCoreActive,
      DamageBoostActive,
      FreezeFieldActive,
      PoisonFieldActive,
      DragonStrikeActive,
      EarthShatterActive,
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
    item = pick @items
    return item 0, 0
