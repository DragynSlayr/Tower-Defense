export class TurretSlagPassive extends PassiveItem
  new: (x, y) =>
    @rarity = @getRandomRarity!
    sprite = Sprite "item/turretSlagPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      for k, t in pairs player.turret
        if t.target
          bullet = Bullet t.position.x, t.position.y - (t.sprite.scaled_height / 2) + 10, t.target, 0
          bullet.sprite = Sprite "projectile/slag.tga", 32, 32, 1, 0.75
          bullet.slagging = true
          Driver\addObject bullet, EntityTypes.bullet
    super x, y, sprite, 1, effect
    @name = "Slag Shot"
    @description = "Turret shoots slagging shots"
