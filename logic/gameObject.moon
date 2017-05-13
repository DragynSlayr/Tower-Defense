export class GameObject
  new: (x, y, sprite, x_speed = 0, y_speed = 0) =>
    @position = Vector x, y
    @speed = Vector x_speed, y_speed
    @sprite = sprite
    @elapsed = 0
    @health = 5
    @max_health = @health
    @damage = 1
    @alive = true
    @id = nil
    @draw_health = true
    @score_value = 0

  getHitBox: =>
    return @sprite\getBounds @position.x, @position.y

  onCollide: (object) =>
    if not @alive return
    --print @__name .. " hit " .. object.__name
    --print "Collision"
    @health -= object.damage

  kill: =>
    score = SCORE + @score_value
    export SCORE = score
    @alive = false
    @health = 0

  update: (dt) =>
    if not @alive return
    @sprite\update dt
    start = Vector @position.x, @position.y
    @elapsed += dt
    @position\add @speed\multiply dt
    radius = @getHitBox!.radius
    @position.x = MathHelper\clamp @position.x, radius, love.graphics.getWidth! - radius
    @position.y = MathHelper\clamp @position.y, radius, love.graphics.getHeight! - radius
    if @id == EntityTypes.bullet
      return
    for k, v in pairs Driver.objects
      for k2, o in pairs v
        if not ((@id == EntityTypes.player and o.id == EntityTypes.turret) or (@id == EntityTypes.turret and o.id == EntityTypes.player))
          if o ~= @ and o.id ~= EntityTypes.bullet
            other = o\getHitBox!
            this = @getHitBox!
            if other\contains this
              @position = start
              dist = other\getCollisionDistance this
              dist = math.sqrt math.sqrt dist
              dist_vec = Vector dist, dist
              if @speed\getLength! > 0
                if @id ~= EntityTypes.player
                  @position\add dist_vec\multiply -1
              if o.speed\getLength! > 0
                if o.id ~= EntityTypes.player
                  o.position\add dist_vec

  draw: =>
    love.graphics.push "all"
    @sprite\draw @position.x, @position.y
    if @draw_health
      love.graphics.setColor 0, 0, 0, 255
      radius = @sprite.scaled_height / 2
      love.graphics.rectangle "fill", (@position.x - radius) - 3, (@position.y + radius) + 3, (radius * 2) + 6, 16
      love.graphics.setColor 0, 255, 0, 255
      ratio = @health / @max_health
      love.graphics.rectangle "fill", @position.x - radius, (@position.y + radius) + 6, (radius * 2) * ratio, 10
    love.graphics.pop!

  isOnScreen: (radius = 0) =>
    if not @alive return false
    circle = @getHitBox!
    circle.radius += radius
    x, y = circle.center\getComponents!
    radius = circle.radius
    xOn = x - radius >= 0 and x + radius <= love.graphics.getWidth!
    yOn = y - radius >= 0 and y + radius <= love.graphics.getHeight!
    return xOn and yOn
