export class Player extends GameObject
  new: (x, y, sprite) =>
    super x, y, sprite
    @attack_range = 50
    @max_speed = 275
    @max_turrets = 1
    @num_turrets = 0
    @turret = {}
    @id = EntityTypes.player
    @repair_range = 30

  keypressed: (key) =>
    if not @alive return
    @last_pressed = key
    @speed.x, @speed.y = switch key
      when "w"
        0, -@max_speed
      when "a"
        -@max_speed, 0
      when "s"
        0, @max_speed
      when "d"
        @max_speed, 0
      else
        @speed.x, @speed.y
    if key == "q"
      x = math.random love.graphics.getWidth!
      y = math.random love.graphics.getHeight!
      enemy = BasicEnemy x, y
      Driver\addObject enemy, EntityTypes.enemy
    if key == "e"
      if @num_turrets != @max_turrets
        @show_turret = not @show_turret
    if key == "space"
      if @show_turret
        turret = BasicTurret @position.x, @position.y
        if turret\isOnScreen! and @num_turrets < @max_turrets
          Driver\addObject turret, EntityTypes.turret
          @num_turrets += 1
          @turret[#@turret + 1] = turret
          @show_turret = false
      else
        if Driver.objects[EntityTypes.enemy]
          for k, v in pairs Driver.objects[EntityTypes.enemy]
            enemy = v\getHitBox!
            player = @getHitBox!
            enemy.radius += player.radius + @attack_range
            if enemy\contains player.center
              v\onCollide @
        if @turret
          for k, v in pairs @turret
            turret = v\getHitBox!
            player = @getHitBox!
            turret.radius += player.radius + @repair_range
            if turret\contains player.center
              v.health += 0.6
              v.health = MathHelper\clamp v.health, 0, v.max_health

  keyreleased: (key) =>
    if not @alive return
    @last_released = key
    if key == "d" or key == "a"
      @speed.x = 0
    elseif key == "w" or key == "s"
      @speed.y = 0

  update: (dt) =>
    if not @alive return
    super dt
    if @show_turret
      turret = BasicTurret @position.x, @position.y
      Renderer\enqueue turret\drawFaded
    for k, v in pairs @turret
      if not v.alive
        @num_turrets -= 1
        @turret[k] = nil

  draw: =>
    if not @alive return
    if DEBUGGING
      love.graphics.push "all"
      love.graphics.setColor 0, 0, 255, 255
      player = @getHitBox!
      love.graphics.circle "fill", @position.x, @position.y, @attack_range + player.radius, 25
      love.graphics.pop!
    super!
