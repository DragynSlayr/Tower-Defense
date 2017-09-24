export class LinearProjectile extends HomingProjectile
  new: (x, y, speed, sprite) =>
    target_pos = Vector speed\getComponents!
    target_pos = target_pos\multiply Screen_Size.width
    target_pos\add (Vector x, y)
    super x, y, (GameObject target_pos.x, target_pos.y, sprite), sprite
    @speed_multiplier = 100
    @damage = 1

  update: (dt) =>
    if not @alive
      return
    if not @target
      @health = 0
    if not @isOnScreen Screen_Size.bounds
      @health = 0

    super dt

    filters = {EntityTypes.player, EntityTypes.turret}
    for k2, filter in pairs filters
      if Driver.objects[filter]
        for k, v in pairs Driver.objects[filter]
          target = v\getHitBox!
          if v.getAttackHitBox
            target = v\getAttackHitBox!
          bullet = @getHitBox!
          bullet.radius += @attack_range
          if target\contains bullet
            @target\onCollide @
            MusicPlayer\play @death_sound
            @kill!
