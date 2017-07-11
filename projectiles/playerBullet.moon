export class PlayerBullet extends HomingProjectile
  new: (x, y, target, damage) =>
    sprite = Sprite "enemy/bullet.tga", 26, 20, 1, 0.5
    super x, y, target, sprite
    @damage = damage
    @trail = nil

  kill: =>
    super!
    if Upgrade.player_special[1]
      if Driver.objects[EntityTypes.player]
        for k, p in pairs Driver.objects[EntityTypes.player]
          p.health += Stats.player[3] * 0.01
          p.health = math.min p.health, p.max_health
