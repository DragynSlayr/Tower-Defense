export class CaptureWave extends Wave
  new: (parent) =>
    super parent
    @target = 3
    @captured = 0
    @dead = 0
    @spawn_time = 2 -- ((0.5 / 3) * @parent.wave_count)
    @spawn_num = {3, 3, 4}
    @spawn_num = @spawn_num[@parent.wave_count]

    x_space = 100
    y_space = 100
    @point_positions = {
      Vector x_space * Scale.width, Screen_Size.height - Screen_Size.border[2] - (y_space * Scale.height),
      Vector Screen_Size.width - (x_space * Scale.width), Screen_Size.height - Screen_Size.border[2] - (y_space * Scale.height),
      Vector Screen_Size.width / 2, Screen_Size.border[2] + (y_space * Scale.height)
    }

  start: =>
    for k, p in pairs @point_positions
      goal = CaptureGoal p.x, p.y
      goal.num = k
      Driver\addObject goal, EntityTypes.goal
    @point_positions = nil
    for i = 1, @spawn_num
      Objectives\spawn EnemyTypes.capture
    Objectives\spawn EnemyTypes.strong

  entityKilled: (entity) =>
    if entity.id == EntityTypes.goal
      if entity.killer
        if entity.killer == EntityTypes.player
          @captured += 1
        else
          @dead += 1

  update: (dt) =>
    super dt
    if not @waiting
      @elapsed += dt
      if @elapsed >= @spawn_time
        @elapsed = 0
        for i = 1, @spawn_num
          Objectives\spawn EnemyTypes.capture
        Objectives\spawn EnemyTypes.strong
    if @dead > 1
      Driver.game_over!
    if @captured >= @target - 1
      @complete = true
      if Driver.objects[EntityTypes.goal]
        for k, o in pairs Driver.objects[EntityTypes.goal]
          Driver\removeObject o, false

  draw: =>
    message = "points"
    num = @target - @captured
    if num == 1
      message = "point"
    @parent.message1 = "\t" .. num .. " " .. message .. " remaining!"
    super!
