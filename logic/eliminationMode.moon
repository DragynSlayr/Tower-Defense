export class EliminationMode extends Mode
  new: (num) =>
    super!
    @target = num
    @killed = 0
    @spawnable = 0
    @spawned = 0

  entityKilled: (entity) =>
    if entity.id == EntityTypes.enemy
      @killed += 1
      if @killed + 1 < @target
        @spawnable += 1

  spawn: (i = 0) =>
    x = math.random love.graphics.getWidth!
    y = math.random love.graphics.getHeight!
    num = math.random 5
    enemy = switch num
      when 1
        PlayerEnemy x, y
      when 2
        TurretEnemy x, y
      when 3
        SpawnerEnemy x, y
      when 4
        StrongEnemy x, y
      else
        BasicEnemy x, y
    touching = false
    for k, v in pairs Driver.objects
      for k2, o in pairs v
        object = o\getHitBox!
        e = enemy\getHitBox!
        if object\contains e
          touching = true
          break
    if touching
      @spawn i + 1
    else
      Driver\addObject enemy, EntityTypes.enemy

  start: =>
    @spawnable = math.min 4, @target

  update: (dt) =>
    super dt
    if not @waiting
      if @spawned + @spawnable <= @target
        for i = 1, @spawnable
          @spawn!
        @spawned += @spawnable
        @spawnable = 0
      if @killed >= @target
        @complete = true

  draw: =>
    @message = "\t" .. (@target - @killed) .. " enemies remaining!"
    super!
