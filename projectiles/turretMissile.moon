export class TurretMissile extends HomingProjectile
  new: (x, y) =>
    sprite = Sprite "projectile/bullet_anim.tga", 32, 16, 0.5, 1.25
    sprite\scaleUniformly 1.25, 1.50
    super x, y, nil, sprite
    @damage = Stats.turret[3] * 15
    @speed_multiplier = 250

    @elapsed = 0
    @wait_time = 2.5
    @moving = false

    --sound = Sound "player_missile.ogg", 0.25, false, 0.50, true
    --@death_sound = MusicPlayer\add sound

  update: (dt) =>
    if @moving
      super dt
    else
      vec = Vector @position.x - @turret_position.x, @position.y - @turret_position.y
      @sprite.rotation = vec\getAngle! + (math.pi / 2)
      @sprite\update dt
      if @elapsed < @wait_time
        @elapsed += dt
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
