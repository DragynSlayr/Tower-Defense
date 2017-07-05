export class CaptureWave extends Wave
  new: (parent) =>
    super parent
    @target = 3
    @captured = 0
    @dead = 0
    @spawn_time = 3 -- ((0.5 / 3) * @parent.wave_count)
    @spawn_num = 3
    @turret_spawn_num = 3
    @goal_complete = false

  start: =>
    Objectives\spawn GoalTypes.tesseract
    if Driver.objects[EntityTypes.goal]
      for k, g in pairs Driver.objects[EntityTypes.goal]
        g.unlocked = true
    for i = 1, @spawn_num
      Objectives\spawn EnemyTypes.capture
    for i = 1, @turret_spawn_num
      Objectives\spawn EnemyTypes.turret

  entityKilled: (entity) =>
    if entity.id == EntityTypes.goal and entity.goal_type == GoalTypes.tesseract
      @goal_complete = true
    elseif entity.id == EntityTypes.enemy and entity.enemyType == EnemyTypes.turret
      Objectives\spawn EnemyTypes.turret

  update: (dt) =>
    super dt
    if not @waiting
      @parent.time_remaining -= dt
      @elapsed += dt
      if @elapsed >= @spawn_time
        @elapsed = 0
        for i = 1, @spawn_num
          Objectives\spawn EnemyTypes.capture
    if @parent.time_remaining <= 0
      Driver.game_over!
    if @goal_complete
      @complete = true
      Driver\killEnemies!
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
