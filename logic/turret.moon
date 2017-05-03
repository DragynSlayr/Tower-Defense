export class Turret extends GameObject
  new: (x, y, range, sprite) =>
    super x, y, sprite, 0, 0
    @range = @sprite\getBounds!.radius + range
    @target = nil
    @id = EntityTypes.turret
    @health = 5
    @max_health = @health

  getHitBox: =>
    radius = math.max @sprite.scaled_height / 2, @sprite.scaled_width / 2
    return Circle @position.x, @position.y, radius

  update: (dt) =>
    if not @alive return
    super dt
    if @target
      enemy = @target\getHitBox!
      turret = @getHitBox!
      dist = Vector enemy.center.x - turret.center.x, enemy.center.y - enemy.center.y
      if dist\getLength! > @range
        @target = nil
        @findTarget!
      else
        --@target\onCollide @
        if @target
          bullet = Bullet @position.x, @position.y, @target
          Driver\addObject bullet, EntityTypes.bullet
          if @target.health <= 0
            @target = nil
            @findTarget!
    else
      @findTarget!

  findTarget: =>
    if not @alive return
    if Driver.objects[EntityTypes.enemy]
      for k, v in pairs Driver.objects[EntityTypes.enemy]
        enemy = v\getHitBox!
        turret = @getHitBox!
        enemy.radius += @range
        if enemy\contains turret.center
          @target = v
          break

  draw: =>
    if not @alive return
    if DEBUGGING or SHOW_RANGE
      love.graphics.push "all"
      love.graphics.setColor 255, 0, 0, 127
      love.graphics.circle "fill", @position.x, @position.y, @range, 25
      love.graphics.pop!
    super!

  drawFaded: =>
    if not @alive return
    love.graphics.push "all"
    r, g, b, a = love.graphics.getColor!
    love.graphics.setColor r, g, b, 50
    love.graphics.circle "fill", @position.x, @position.y, @range, 25
    @sprite\draw @position.x, @position.y
    love.graphics.pop!

  isOnScreen: =>
    if not @alive return false
    circle = @getHitBox!
    x, y = circle.center\getComponents!
    radius = @range
    xOn = x - radius >= 0 and x + radius <= love.graphics.getWidth!
    yOn = y - radius >= 0 and y + radius <= love.graphics.getHeight!
    return xOn and yOn
