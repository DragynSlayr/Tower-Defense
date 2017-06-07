export class Turret extends GameObject
  new: (x, y, range, sprite) =>
    super x, y, sprite, 0, 0
    @max_health = Stats.turret[1]
    @damage     = Stats.turret[3]
    @health = @max_health
    @range = range

    @target = nil

    @id = EntityTypes.turret
    @draw_health = false

    @shield_available = true

    @sprite\setShader love.graphics.newShader "shaders/health.fs"

  getHitBox: =>
    radius = math.max @sprite.scaled_height / 2, @sprite.scaled_width / 2
    return Circle @position.x, @position.y, radius

  update: (dt) =>
    if not @alive return
    @sprite.shader\send "health", @health / @max_health
--    if Driver.objects[EntityTypes.player]
--      if #Driver.objects[EntityTypes.player] ~= 0
--        @speed = Driver.objects[EntityTypes.player][#Driver.objects[EntityTypes.player]].speed\multiply -1
    super dt
    if Upgrade.turret_special[2]
      if @health <= (@max_health / 2) and @shield_available
        @shield_available = false
        @shielded = true
        if Driver.objects[EntityTypes.player]
          for k, v in pairs Driver.objects[EntityTypes.player]
            v.shielded = true
        if Driver.objects[EntityTypes.goal]
          for k, v in pairs Driver.objects[EntityTypes.goal]
            if v.goal_type == GoalTypes.defend
              v.shielded = true
    if Upgrade.turret_special[3]
      if Driver.objects[EntityTypes.enemy]
        for k, e in pairs Driver.objects[EntityTypes.enemy]
          enemy = e\getHitBox!
          turret = @getHitBox!
          turret.radius += @range
          if enemy\contains turret
            bullet = Bullet @position.x, @position.y - @sprite.scaled_height / 2 + 10, e, @damage
            Driver\addObject bullet, EntityTypes.bullet
    else
      if @target
        enemy = @target\getHitBox!
        turret = @getHitBox!
        dist = Vector enemy.center.x - turret.center.x, enemy.center.y - turret.center.y
        if dist\getLength! > @range
          @target = nil
          @findTarget!
        else
          --@target\onCollide @
          if @target
            bullet = Bullet @position.x, @position.y - @sprite.scaled_height / 2 + 10, @target, @damage
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
        turret.radius += @range
        if enemy\contains turret
          if v.alive
            @target = v
            break

  draw: =>
    if not @alive return
    if DEBUGGING-- or SHOW_RANGE
      love.graphics.push "all"
      love.graphics.setColor 255, 0, 0, 127
      love.graphics.circle "fill", @position.x, @position.y, @range, 360
      love.graphics.pop!
    super!
    love.graphics.push "all"
    font = Renderer.small_font
    love.graphics.setFont font
    message = math.floor ((@health / @max_health) * 100)
    message ..= " %"
    love.graphics.setColor 0, 0, 0, 50
    love.graphics.rectangle "fill", @position.x - (@sprite.scaled_width / 2) - (5 * Scale.width), @position.y + (@sprite.scaled_height / 2), @sprite.scaled_width + (12 * Scale.width), font\getHeight! + (2 * Scale.height), 4 * Scale.diag
    love.graphics.setColor 0, 255, 0, 255
    love.graphics.printf message, @position.x - ((font\getWidth message) / 2), @position.y + (@sprite.scaled_height / 2), @sprite.scaled_width + (10 * Scale.width), "center"
    love.graphics.pop!

  drawFaded: =>
    if not @alive return
    love.graphics.push "all"
    love.graphics.setColor 100, 100, 100, 127
    love.graphics.circle "fill", @position.x, @position.y, @range, 360
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
