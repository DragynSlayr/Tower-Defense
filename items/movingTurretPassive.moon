export class MovingTurretPassive extends PassiveItem
  new: (x, y) =>
    @rarity = 5
    sprite = Sprite "item/movingTurret.tga", 32, 32, 1, 1.75
    effect = (player) =>
      speed = Vector -player.speed.x, -player.speed.y
      for k, t in pairs player.turret
        t.speed = speed
    super x, y, sprite, 0, effect
    @name = "Moving Turret"
    @description = "Your turret moves"
