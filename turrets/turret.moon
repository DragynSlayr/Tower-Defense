export class Turret extends GameObject
  new: (x, y, range, sprite, cooldown) =>
    super x, y, sprite, 0, 0
    @colliders = {EntityTypes.enemy, EntityTypes.boss}

    @max_health   = Stats.turret[1]
    @damage       = Stats.turret[3]
    @attack_speed = Stats.turret[5]
    @health = @max_health
    @range = range
    @attack_timer = 0
    @cooldown = cooldown

    @target = nil

    @id = EntityTypes.turret
    @draw_health = false
    @draw_health_message = true

    @shield_available = true

    @sprite\setShader love.graphics.newShader "shaders/health.fs"

    @multitarget = false

    @shot_position = Vector 0, (-@sprite.scaled_height / 2) + 10

  getStats: =>
    stats = {}
    stats[1] = @max_health
    stats[2] = @range
    stats[3] = @damage
    stats[4] = @cooldown
    stats[5] = @attack_speed
    return stats

  getAttackHitBox: =>
    radius = math.max @sprite.scaled_height / 2, @sprite.scaled_width / 2
    return Circle @position.x, @position.y, radius

  getHitBox: =>
    return Rectangle @position.x - (@sprite.scaled_width / 2), @position.y - (@sprite.scaled_height / 2), @sprite.scaled_width, @sprite.scaled_height

  update: (dt) =>
    if not @alive return
    @sprite.shader\send "health", @health / @max_health
    @sprite.should_shade = Objectives.shader == nil
    super dt
    attacked = false
    @attack_timer += dt
    if @attack_timer >= @attack_speed
      if @multitarget
        filters = {EntityTypes.enemy, EntityTypes.boss}
        for k2, filter in pairs filters
          for k, e in pairs Driver.objects[filter]
            enemy = e\getHitBox!
            turret = @getAttackHitBox!
            turret.radius += @range
            if enemy\contains turret
              @fire!
              attacked = true
      else
        if @target and @target.alive
          enemy = @target\getHitBox!
          turret = @getHitBox!
          dist = Vector enemy.center.x - turret.center.x, enemy.center.y - turret.center.y
          if dist\getLength! > @range
            @target = nil
            @findTarget!
          else
            --@target\onCollide @
            if @target
              @fire!
              attacked = true
              if @target.health <= 0
                @target = nil
                @findTarget!
        else
          @findTarget!
    if attacked
      @attack_timer = 0

  fire: =>
    bullet = Bullet @position.x + @shot_position.x, @position.y + @shot_position.y, @target, @damage
    Driver\addObject bullet, EntityTypes.bullet

  findTarget: =>
    closest = nil
    closest_distance = math.max Screen_Size.width * 2, Screen_Size.height * 2
    for k, v in pairs Driver.objects[EntityTypes.enemy]
      player = v\getHitBox!
      enemy = @getAttackHitBox!
      dist = Vector enemy.center.x - player.center.x, enemy.center.y - player.center.y
      if dist\getLength! < closest_distance
        closest_distance = dist\getLength!
        closest = v
    for k, v in pairs Driver.objects[EntityTypes.boss]
      turret = v\getHitBox!
      enemy = @getAttackHitBox!
      dist = Vector enemy.center.x - turret.center.x, enemy.center.y - turret.center.y
      if dist\getLength! < closest_distance
        closest_distance = dist\getLength!
        closest = v
    @target = closest

  draw: =>
    if not @alive return
    if DEBUGGING-- or SHOW_RANGE
      love.graphics.push "all"
      setColor 255, 0, 0, 127
      love.graphics.circle "fill", @position.x, @position.y, @range, 360
      love.graphics.pop!
    super!
    love.graphics.push "all"
    love.graphics.setShader Driver.shader
    if @draw_health_message
      font = (Renderer\newFont 20)
      love.graphics.setFont font
      --message = math.floor ((@health / @max_health) * 100)
      --message ..= " %"
      h = string.format "%.1f", @health
      m = string.format "%.1f", @max_health
      message = h .. " / " .. m
      width = (font\getWidth message) + (5 * Scale.width)
      height = font\getHeight!
      setColor 0, 0, 0, 50
      love.graphics.rectangle "fill", @position.x - (width / 2) - (2 * Scale.width), @position.y + (@sprite.scaled_height / 2), width + (4 * Scale.width), height + (2 * Scale.height), 4 * Scale.diag
      setColor 0, 255, 0, 255
      love.graphics.printf message, @position.x - (width / 2), @position.y + (@sprite.scaled_height / 2), width, "center"
    love.graphics.setShader!
    love.graphics.pop!

  drawFaded: =>
    if not @alive return
    love.graphics.push "all"
    setColor 100, 100, 100, 127
    love.graphics.circle "fill", @position.x, @position.y, @range, 360
    @sprite\draw @position.x, @position.y
    love.graphics.pop!

  isOnScreen: =>
    if not @alive return false
    circle = @getHitBox!
    x, y = circle.center\getComponents!
    radius = @range
    xOn = x - radius >= 0 and x + radius <= Screen_Size.width
    yOn = y - radius >= 0 and y + radius <= Screen_Size.height
    return xOn and yOn
