export class TurretShieldPassive extends PassiveItem
  @lowest_rarity = 5
  new: (rarity) =>
    @rarity = rarity
    sprite = Sprite "item/turretShieldPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      for k2, turret in pairs player.turret
        if turret.shield_available and turret.health <= (turret.max_health / 2)
          turret.shield_available = false
          for k, t in pairs Driver.objects[EntityTypes.turret]
            t.shielded = true
          for k, v in pairs Driver.objects[EntityTypes.player]
            v.shielded = true
          for k, v in pairs Driver.objects[EntityTypes.goal]
            if v.goal_type == GoalTypes.defend
              v.shielded = true
          break
    super sprite, 0, effect
    @name = "Turret Shield"
    @description = "Allies receive a temporary shield when a turret gets to half health"
