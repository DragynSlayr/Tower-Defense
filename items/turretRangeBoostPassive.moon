export class TurretRangeBoostPassive extends PassiveItem
  @lowest_rarity = 5
  new: (rarity) =>
    @rarity = rarity
    -- TODO: This sprite needs work
    sprite = Sprite "item/turretRangeBoostPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      boosted = false
      for k, t in pairs player.turret
        if t.alive
          turret = t\getAttackHitBox!
          p = player\getHitBox!
          p.radius += t.range / 5
          if turret\contains p
            boosted = true
            break
      if boosted
        player.range_boost = player.attack_range
      else
        player.range_boost = 0
    super sprite, 0, effect
    @name = "High ground"
    @description = "Double range near turret"
