export class CaptureGoal extends GameObject
  new: (x, y) =>
    sprite = Sprite "flag.tga", 34, 16, 1, 2.5
    super x, y, sprite
    @id = EntityTypes.goal
    @goal_type = GoalTypes.capture
    @health = 10 + (5.5 * Objectives\getLevel!)
    @max_health = @health
    @health /= 2
    @killer = nil
    @last_hit = nil
    @enabled = true
    @lock_timer = 0
    @disable_time = 5

  onCollide: (entity) =>
    if entity.id == EntityTypes.enemy and entity.enemyType == EnemyTypes.capture
      Driver\removeObject entity, false
      if @enabled
        @health -= entity.damage
    else
      if @enabled
        super entity
    if @enabled
      if math.random! < (0.25 / 60)
        @enabled = false
      @last_hit = entity.id

  kill: =>
    super!
    @killer = @last_hit

  update: (dt) =>
    if @health >= @max_health
      @alive = false
    if @alive
      super dt
    @lock_timer += dt
    if @lock_timer >= @disable_time and not @enabled
      @lock_timer = 0
      @enabled = true

  draw: =>
    super!
    love.graphics.push "all"
    if @draw_health
      love.graphics.setShader Driver.shader
      love.graphics.setColor 0, 0, 0, 255
      radius = @sprite.scaled_height / 2
      love.graphics.rectangle "fill", (@position.x - radius) - (3 * Scale.width), (@position.y + radius) + (3 * Scale.height), (radius * 2) + (6 * Scale.width), 16 * Scale.height

      if @enabled
        love.graphics.setColor 0, 127, 255, 255
        ratio = @health / @max_health
        love.graphics.rectangle "fill", @position.x - radius, (@position.y + radius) + (6 * Scale.height), (radius * 2) * ratio, 10 * Scale.height

        love.graphics.setColor 255, 127, 0, 255
        love.graphics.rectangle "fill", @position.x - radius + ((radius * 2) * ratio), (@position.y + radius) + (6 * Scale.height), (radius * 2) * (1 - ratio), 10 * Scale.height
      else
        love.graphics.setColor 0, 255, 0, 255
        love.graphics.rectangle "fill", @position.x - radius, (@position.y + radius) + (6 * Scale.height), radius * 2, 10 * Scale.height

      love.graphics.setShader!
    love.graphics.pop!
