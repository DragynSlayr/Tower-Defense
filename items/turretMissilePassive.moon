export class TurretMissilePassive extends PassiveItem
  @lowest_rarity = 5
  new: (rarity) =>
    @rarity = rarity
    -- TODO: This sprite needs work
    sprite = Sprite "item/turretMissilePassive.tga", 32, 32, 1, 1.75
    @old_num = 0
    @num_missiles = 12
    @angle = 2 * math.pi * (1 / @num_missiles)
    effect = (player) =>
      if @old_num < player.num_turrets
        for k, t in pairs player.turret
          point = Vector t\getHitBox!.radius + (20 * Scale.diag), 0
          for i = 1, @num_missiles
            missile = TurretMissile t.position.x + point.x, t.position.y + point.y
            missile\setTurret t
            if (i % 2) == 0
              missile.rotation_direction = -1
            Driver\addObject missile, EntityTypes.bullet
            point\rotate @angle
      @old_num = player.num_turrets
    super sprite, 0, effect
    @name = "Burst"
    @description = "A barrage of bullets is fired when turrets are placed"
