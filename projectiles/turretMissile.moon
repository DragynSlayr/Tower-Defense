export class TurretMissile extends HomingProjectile
  new: (x, y) =>
    sprite = Sprite "projectile/bullet_anim.tga", 32, 16, 0.5, 1.25
    sprite\setScale 0.95, 1.65
    super x, y, nil, sprite
    @damage = Stats.turret[3] * 15
    @speed_multiplier = 500

    @elapsed = 0
    @wait_time = 2.5
    @moving = false

    @rotation_direction = 1

    --sound = Sound "player_missile.ogg", 0.25, false, 0.50, true
    --@death_sound = MusicPlayer\add sound

  setTurret: (turret) =>
    @turret = turret
    vec = Vector @position.x - @turret.position.x, @position.y - @turret.position.y
    @sprite.rotation = vec\getAngle! + math.pi
    @start_rotation = @sprite.rotation

  update: (dt) =>
    if @moving
      super dt
    else
      @sprite\update dt
      if @elapsed < @wait_time
        @elapsed += dt
        @sprite.rotation = @start_rotation + (@rotation_direction * (2 * math.pi) * (@elapsed / @wait_time))
        @position\add (@turret.position\multiply -1)
        scale = (500 * @elapsed) + 750
        @position\rotate ((@rotation_direction * 2 * math.pi) / scale)
        @position\add @turret.position
      else
        @moving = true
        @target = @findTarget!
        if not @target
          @kill!

  draw: =>
    if @moving
      super!
    else
      @sprite\draw @position.x, @position.y
      if DEBUGGING
        @getHitBox!\draw!

  findTarget: =>
    targets = {}
    if Driver.objects[EntityTypes.enemy]
      targets = concatTables targets, Driver.objects[EntityTypes.enemy]
    if Driver.objects[EntityTypes.boss]
      targets = concatTables targets, Driver.objects[EntityTypes.boss]
    if Driver.objects[EntityTypes.goal]
      goals = {GoalTypes.attack, GoalTypes.capture, GoalTypes.tesseract}
      for k, g in pairs Driver.objects[EntityTypes.goal]
        if tableContains goals, g.goal_type
          table.insert targets, g
    return pick targets
