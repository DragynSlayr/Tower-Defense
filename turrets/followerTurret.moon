export class FollowerTurret extends Turret
  new: (x, y, player) =>
    sprite = Sprite "turret/follower.tga", 26, 32, 1, 1.5
    super x, y, Stats.turret[2], sprite, player.turret_cooldown
    @shot_position = Vector 0, 0
    @draw_health_message = false
    @max_speed = player.max_speed * 0.675
    @sep_dist = 75 * Scale.diag
    @player = player

  update: (dt) =>
    speed = Vector @player.position.x - @position.x, @player.position.y - @position.y
    if speed\getLength! >= @sep_dist
      speed\toUnitVector!
      @speed = speed\multiply @max_speed
    else
      @speed = Vector 0, 0
    super dt

  fire: =>
    bullet = Bullet @position.x + @shot_position.x, @position.y + @shot_position.y, @target, @damage
    bullet.sprite = Sprite "projectile/beam.tga", 16, 8, 1, 1
    Driver\addObject bullet, EntityTypes.bullet
