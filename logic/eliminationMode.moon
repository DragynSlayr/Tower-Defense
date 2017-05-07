export class EliminationMode
  new: (num) =>
    @target = num
    @killed = 0
    @spawnable = 0
    @elapsed = 0
    @delay = 5
    @waiting = true
    @complete = false
    @spawned = 0

  entityKilled: (entity) =>
    if entity.id == EntityTypes.enemy
      @killed += 1
      if @killed + 1 < @target
        @spawnable += 1

  spawn: (i = 0) =>
    --if i > 0
      --print i
    x = math.random love.graphics.getWidth!
    y = math.random love.graphics.getHeight!
    num = math.random 5
    --print num
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

  update: (dt) =>
    if @waiting
      @elapsed += dt
      if @elapsed >= @delay
        @spawnable = math.min 4, @target
        @waiting = false
    else
      if @spawned + @spawnable <= @target
        for i = 1, @spawnable
          @spawn!
        @spawned += @spawnable
        @spawnable = 0
    if @killed >= @target
      @complete = true

  draw: =>
    love.graphics.push "all"
    love.graphics.setColor(0, 0, 0, 255)
    message = "\t" .. (@target - @killed) .. " enemies remaining!"
    Renderer\drawAlignedMessage message, 20, "left", Renderer.hud_font
    love.graphics.pop!
