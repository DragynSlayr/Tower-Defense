export class Player extends GameObject
  new: (x, y, sprite) =>
    super x, y, sprite
    @attack_range = 35
    @max_speed = 275
    @max_turrets = 1
    @num_turrets = 0
    @turret = {}
    @id = EntityTypes.player
    @repair_range = 30

  keypressed: (key) =>
    if not @alive return
    @last_pressed = key
    if key == "a"
      --if @speed.x ~= @max_speed
        @speed.x = -@max_speed
    elseif key == "d"
      --if @speed.x ~= -@max_speed
        @speed.x = @max_speed
    elseif key == "w"
      --if @speed.y ~= @max_speed
        @speed.y = -@max_speed
    elseif key == "s"
      --if @speed.y ~= -@max_speed
        @speed.y = @max_speed
    if key == "q"
      if DEBUGGING
        x = math.random love.graphics.getWidth!
        y = math.random love.graphics.getHeight!
        enemy = BasicEnemy x, y
        Driver\addObject enemy, EntityTypes.enemy
    elseif key == "e"
      if @num_turrets != @max_turrets
        @show_turret = not @show_turret
    elseif key == "space"
      if @show_turret
        turret = BasicTurret @position.x, @position.y
        --if turret\isOnScreen! and @num_turrets < @max_turrets
        if @num_turrets < @max_turrets
          Driver\addObject turret, EntityTypes.turret
          @num_turrets += 1
          @turret[#@turret + 1] = turret
          @show_turret = false
      --else
        --if Driver.objects[EntityTypes.enemy]
          --for k, v in pairs Driver.objects[EntityTypes.enemy]
            --enemy = v\getHitBox!
            --player = @getHitBox!
            --enemy.radius += player.radius + @attack_range
            --if enemy\contains player.center
              --v\onCollide @
              --v.speed_multiplier = 0
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
    --if key == "a"
      --if @speed.x == -@max_speed
        --@speed.x = 0
    --elseif key == "d"
      --if @speed.x == @max_speed
        --@speed.x = 0
    --elseif key == "w"
      --if @speed.y == -@max_speed
        --@speed.y = 0
    --elseif key == "s"
      --if @speed.y == @max_speed
        --@speed.y = 0

    if key == "d" or key == "a"
      @speed.x = 0
    elseif key == "w" or key == "s"
      @speed.y = 0

  update: (dt) =>
    if not @alive return
    super dt
    if Driver.objects[EntityTypes.enemy]
      for k, v in pairs Driver.objects[EntityTypes.enemy]
        enemy = v\getHitBox!
        player = @getHitBox!
        enemy.radius += player.radius + @attack_range
        if enemy\contains player.center
          bullet = PlayerBullet @position.x, @position.y, v
          Driver\addObject bullet, EntityTypes.bullet
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

  kill: =>
    super\kill!
    player = Player @position.x, @position.y, @sprite
    Driver\addObject player, EntityTypes.player
