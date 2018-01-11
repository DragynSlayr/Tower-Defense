export class TurretSlagPassive extends PassiveItem
  @lowest_rarity = 4
  new: (rarity) =>
    @rarity = rarity
    sprite = Sprite "item/turretSlagPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      if Driver.objects[EntityTypes.turret]
        for k, t in pairs Driver.objects[EntityTypes.turret]
          if t.target
            bullet = Bullet t.position.x, t.position.y - (t.sprite.scaled_height / 2) + 10, t.target, 0
            bullet.sprite = Sprite "projectile/slag.tga", 32, 32, 1, 0.75
            bullet.slagging = true
            Driver\addObject bullet, EntityTypes.bullet
    super sprite, 1, effect
    @name = "Huge Impairment"
    @description = "Turret shoots slagging shots"
