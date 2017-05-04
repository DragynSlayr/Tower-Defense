export class Player extends GameObject
  new: (x, y, sprite) =>
    super x, y, sprite
    @attack_range = 75
    @max_speed = 275
    @max_turrets = 1
    @num_turrets = 0
    @turret = {}
    @id = EntityTypes.player
    @repair_range = 30
    @can_place = true
    @turret_cooldown = 20
    @keys_pushed = 0

  keypressed: (key) =>
    if not @alive return
    @last_pressed = key
    if key == "a"
      @speed.x -= @max_speed
    elseif key == "d"
      @speed.x += @max_speed
    elseif key == "w"
      @speed.y -= @max_speed
    elseif key == "s"
      @speed.y += @max_speed
    for k, v in pairs {"w", "a", "s", "d"}
      if key == v
        @keys_pushed += 1

    if key == "q"
      if DEBUGGING
        x = math.random love.graphics.getWidth!
        y = math.random love.graphics.getHeight!
        enemy = BasicEnemy x, y
        Driver\addObject enemy, EntityTypes.enemy
    elseif key == "e"
      if @num_turrets != @max_turrets and @can_place
        @show_turret = not @show_turret
    elseif key == "space"
      if @show_turret
        turret = BasicTurret @position.x, @position.y
        if @num_turrets < @max_turrets
          Driver\addObject turret, EntityTypes.turret
          @num_turrets += 1
          @turret[#@turret + 1] = turret
          @show_turret = false
          @can_place = false
          @elapsed = 0
      if @turret
        for k, v in pairs @turret
          turret = v\getHitBox!
          player = @getHitBox!
          turret.radius += player.radius + @repair_range
          if turret\contains player.center
            v.health += 0.6
            v.health = MathHelper\clamp v.health, 0, v.max_health
    elseif key == "z"
      export SHOW_RANGE = not SHOW_RANGE
    elseif key == "`"
      export DEBUGGING = not DEBUGGING

  keyreleased: (key) =>
    if not @alive return
    @last_released = key
    if @keys_pushed > 0
      if key == "a"
        @speed.x += @max_speed
      elseif key == "d"
        @speed.x -= @max_speed
      elseif key == "w"
        @speed.y += @max_speed
      elseif key == "s"
        @speed.y -= @max_speed
      for k, v in pairs {"w", "a", "s", "d"}
        if key == v
          @keys_pushed -= 1

  update: (dt) =>
    if not @alive return
    if @keys_pushed == 0
      @speed = Vector 0, 0
    super dt
    if @elapsed > @turret_cooldown
      @can_place = true
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
    if DEBUGGING or SHOW_RANGE
      love.graphics.push "all"
      love.graphics.setColor 0, 0, 255, 100
      player = @getHitBox!
      love.graphics.circle "fill", @position.x, @position.y, @attack_range + player.radius, 25
      love.graphics.pop!
    super!
    remaining = MathHelper\clamp @turret_cooldown - @elapsed, 0, @turret_cooldown
    remaining = math.floor remaining
    message = ""
    if remaining == 0 or @can_place
      message = "Turret Available!\t"
    else
      message = "Turret Cooldown " .. remaining .. " seconds\t"
    Renderer\drawAlignedMessage message, 20, "right", Renderer.hud_font

  kill: =>
    super\kill!
    player = Player @position.x, @position.y, @sprite
    Driver\addObject player, EntityTypes.player
