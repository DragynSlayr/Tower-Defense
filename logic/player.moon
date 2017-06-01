export class Player extends GameObject
  new: (x, y) =>
    sprite = Sprite "test.tga", 16, 16, 0.29, 4
    super x, y, sprite
    @sprite\setRotationSpeed -math.pi / 2

    @max_health      = Stats.player[1]
    @attack_range    = Stats.player[2]
    @damage          = Stats.player[3]
    @max_speed       = Stats.player[4]
    @turret_cooldown = Stats.turret[4]
    @health = @max_health
    @repair_range = 30 * Scale.diag
    @keys_pushed = 0
    @hit = false

    @id = EntityTypes.player
    @draw_health = false

    @can_place = true
    @max_turrets = 1
    @num_turrets = 0
    @turret = {}

  onCollide: (object) =>
    super object
    @hit = true

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
          player.radius += @repair_range
          if turret\contains player
            v.health += 1
            v.health = clamp v.health, 0, v.max_health
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
        player.radius += @attack_range
        if enemy\contains player
          bullet = PlayerBullet @position.x, @position.y, v, @damage
          Driver\addObject bullet, EntityTypes.bullet
    if Driver.objects[EntityTypes.goal]
      for k, v in pairs Driver.objects[EntityTypes.goal]
        if v.goal_type == GoalTypes.attack
          goal = v\getHitBox!
          player = @getHitBox!
          player.radius += @attack_range
          if goal\contains player
            bullet = PlayerBullet @position.x, @position.y, v, @damage
            Driver\addObject bullet, EntityTypes.bullet
        else if v.goal_type == GoalTypes.find
          goal = v\getHitBox!
          player = @getHitBox!
          player.radius += 5
          if goal\contains player
            v\onCollide @
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
      love.graphics.circle "fill", @position.x, @position.y, @attack_range + player.radius, 360
      love.graphics.pop!
    super!

    love.graphics.setColor 255, 255, 255, 255
    love.graphics.rectangle "fill", 9 * Scale.width, love.graphics.getHeight! - (52 * Scale.height), 202 * Scale.width, 43 * Scale.height

    remaining = clamp @turret_cooldown - @elapsed, 0, @turret_cooldown
    remaining = math.floor remaining
    love.graphics.setColor 0, 0, 0, 255
    love.graphics.rectangle "fill", 10 * Scale.width, love.graphics.getHeight! - (51 * Scale.height), 200 * Scale.width, 20 * Scale.height
    love.graphics.setColor 0, 0, 255, 255
    ratio = 1 - (remaining / @turret_cooldown)
    if remaining == 0 or @can_place
      ratio = 1
    love.graphics.rectangle "fill", 13 * Scale.width, love.graphics.getHeight! - (48 * Scale.height), 194 * ratio * Scale.width, 14 * Scale.height

    turret_health = 0
    num = 0
    if Driver.objects[EntityTypes.turret]
      for k, t in pairs Driver.objects[EntityTypes.turret]
        turret_health += t.health
        num += t.max_health
    else
      turret_health = 1
      num = 1
    ratio = turret_health / num

    love.graphics.setColor 0, 0, 0, 255
    love.graphics.rectangle "fill", 10 * Scale.width, love.graphics.getHeight! - (30 * Scale.height), 200 * Scale.width, 20 * Scale.height
    love.graphics.setColor 0, 255, 0, 255
    love.graphics.rectangle "fill", 13 * Scale.width, love.graphics.getHeight! - (27 * Scale.height), 194 * ratio * Scale.width, 14 * Scale.height

    love.graphics.setColor 0, 0, 0, 255
    love.graphics.rectangle "fill", (love.graphics.getWidth! / 2) - (200 * Scale.width), love.graphics.getHeight! - (30 * Scale.height), 400 * Scale.width, 20 * Scale.height
    love.graphics.setColor 255, 0, 0, 255
    ratio = @health / @max_health
    love.graphics.rectangle "fill", (love.graphics.getWidth! / 2) - (197 * Scale.width), love.graphics.getHeight! - (27 * Scale.height), 394 * ratio * Scale.width, 14 * Scale.height

  kill: =>
    super\kill!
    Driver.game_over!
    --player = Player @position.x, @position.y
    --Driver\addObject player, EntityTypes.player
