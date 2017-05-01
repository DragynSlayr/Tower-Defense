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

  update: (dt) =>
    if @waiting
      @elapsed += dt
      if @elapsed >= @delay
        @spawnable = math.min 4, @target
        @waiting = false
    else
      if @spawned + @spawnable <= @target
        for i = 1, @spawnable
          x = math.random love.graphics.getWidth!
          y = math.random love.graphics.getHeight!
          enemy = BasicEnemy x, y
          Driver\addObject enemy, EntityTypes.enemy
        @spawned += @spawnable
        @spawnable = 0
    if @killed >= @target
      @complete = true

  draw: =>
    love.graphics.push "all"
    love.graphics.setColor(0, 0, 0, 255)
    message = (@target - @killed) .. " enemies remaining!"
    Renderer\drawHUDMessage message, 10, 10
    love.graphics.pop!
