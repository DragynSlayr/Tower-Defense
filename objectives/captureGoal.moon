export class CaptureGoal extends GameObject
  new: (x, y) =>
    sprite = Sprite "objective/flag.tga", 34, 16, 1, 2.5
    super x, y, sprite
    @id = EntityTypes.goal
    @goal_type = GoalTypes.capture
    @health = 10
    @max_health = @health
    @capture_amount = @health / 2
    @draw_health = false
    @unlocked = false

  onCollide: (entity) =>
    if @unlocked
      if entity.id == EntityTypes.enemy and entity.enemyType == EnemyTypes.capture
        @capture_amount -= entity.damage
        entity.health = 0
      else
        if entity.__class == Missile
          @capture_amount += 2
        else
          @capture_amount += 2 / 60
      @capture_amount = clamp @capture_amount, 0, @max_health

  update: (dt) =>
    super dt
    @capture_amount = clamp @capture_amount, 0, @max_health

  draw: =>
    super!
    love.graphics.push "all"
    love.graphics.setShader Driver.shader

    love.graphics.setColor 0, 0, 0, 255
    radius = @sprite.scaled_height / 2
    love.graphics.rectangle "fill", (@position.x - radius) - (3 * Scale.width), (@position.y + radius) + (3 * Scale.height), (radius * 2) + (6 * Scale.width), 16 * Scale.height

    love.graphics.setColor 0, 127, 255, 255
    ratio = @capture_amount / @max_health
    love.graphics.rectangle "fill", @position.x - radius, (@position.y + radius) + (6 * Scale.height), (radius * 2) * ratio, 10 * Scale.height

    love.graphics.setColor 255, 127, 0, 255
    love.graphics.rectangle "fill", @position.x - radius + ((radius * 2) * ratio), (@position.y + radius) + (6 * Scale.height), (radius * 2) * (1 - ratio), 10 * Scale.height

    love.graphics.setShader!
    love.graphics.pop!
