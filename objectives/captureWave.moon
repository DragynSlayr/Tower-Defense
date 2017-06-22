export class CaptureWave extends Wave
  new: (parent) =>
    super parent
    @target = 3
    @captured = 0
    @dead = 0
    @spawn_time = 2 -- ((0.5 / 3) * @parent.wave_count)
    --@spawn_num = {3, 3, 4}
    @spawn_num = 3--@spawn_num[@parent.wave_count]
    @turret_spawn_timer = 0
    @turret_spawn_time = 5
    @turret_spawn_num = 3
    @goal_complete = false

  start: =>
    Objectives\spawn GoalTypes.tesseract
    if Driver.objects[EntityTypes.goal]
      for k, g in pairs Driver.objects[EntityTypes.goal]
        g.unlocked = true
    for i = 1, @spawn_num
      Objectives\spawn EnemyTypes.capture
    Objectives\spawn EnemyTypes.turret

  entityKilled: (entity) =>
    if entity.id == EntityTypes.goal and entity.goal_type == GoalTypes.tesseract
      @goal_complete = true
      --if entity.killer
        --if entity.killer == EntityTypes.player
          --@captured += 1
        --else
          --@dead += 1

  update: (dt) =>
    super dt
    if not @waiting
      @parent.time_remaining -= dt
      @elapsed += dt
      @turret_spawn_timer += dt
      if @elapsed >= @spawn_time
        @elapsed = 0
        for i = 1, @spawn_num
          Objectives\spawn EnemyTypes.capture
      if @turret_spawn_timer >= @turret_spawn_time
        @turret_spawn_timer = 0
        for i = 1, @turret_spawn_num
          Objectives\spawn EnemyTypes.turret
    if @parent.time_remaining <= 0
      Driver.game_over!
    if @goal_complete--@captured >= @target - 1
      @complete = true
      Driver\killEnemies!
      --Driver\clearObjects EntityTypes.goal
      if Driver.objects[EntityTypes.goal]
        for k, o in pairs Driver.objects[EntityTypes.goal]
          o.unlocked = false

  draw: =>
    message = "seconds"
    num = math.floor @parent.time_remaining
    if num == 1
      message = "second"
    @parent.message1 = "\t" .. num .. " " .. message .. " remaining!"
    super!
