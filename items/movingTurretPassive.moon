export class MovingTurretPassive extends PassiveItem
  new: =>
    sprite = Sprite "item/movingTurret.tga", 32, 32, 1, 1.75
    effect = (player) =>
      multipliers = {-1, 1}
      for k, t in pairs player.turret
        radius = t\getAttackHitBox!.radius * 1
        if t.speed\getLength! == 0
          t.speed = Vector (pick multipliers) * player.max_speed * 0.5, (pick multipliers) * player.max_speed * 0.5
        if t.position.x - radius <= Screen_Size.border[1] or t.position.x + radius >= Screen_Size.border[3]
          t.speed = Vector t.speed.x * -1, t.speed.y
        if t.position.y - radius <= Screen_Size.border[2] or t.position.y + radius >= Screen_Size.border[4] + Screen_Size.border[2]
          t.speed = Vector t.speed.x, t.speed.y * -1
    super sprite, 0, effect
    @name = "Moving Turret"
    @description = "Your turret moves"
