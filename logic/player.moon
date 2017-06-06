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

    @range_boost   = 0
    @speed_boost   = 0
    @bomb_timer    = 0
    @max_bomb_time = 7

    @id = EntityTypes.player
    @draw_health = false

    @can_place = true
    @max_turrets = 1
    if Upgrade.turret_special[1]
      @max_turrets = 2
    @num_turrets = 0
    @turret = {}

    @font = Renderer\newFont 20

    @globes = {}
    @globe_index = 1

    bounds = @getHitBox!
    width = bounds.radius + @attack_range
    num = 5
    --width = 0
    --num = 1
    for i = 1, num
      angle = ((math.pi * 2) / num) * i
      vec = Vector width, 0
      vec\rotate angle
      @globes[i] = Vector vec.x, vec.y

  onCollide: (object) =>
    if not @alive return
    if @shielded
      if object.id == EntityTypes.enemy and object.enemyType == EnemyTypes.turret
        @health -= object.damage / 2
      else
        @health -= object.damage
      @hit = true
    else
      @shielded = false

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
      if @can_place
        if @num_turrets != @max_turrets
          @show_turret = not @show_turret
        else
          if Upgrade.turret_special[4]
            for k, v in pairs @turret
              turret = v\getHitBox!
              player = @getHitBox!
              player.radius += @repair_range
              if turret\contains player
                @num_turrets -= 1
                @turret[k] = nil
                Driver\removeObject v, false
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
    else
      start = Vector @speed.x, @speed.y
      boost = Vector @speed_boost, 0
      angle = @speed\getAngle!
      boost\rotate angle
      @speed\add boost
      super dt
      @speed = start
    @bomb_timer += dt
    if @bomb_timer >= @max_bomb_time
      @bomb_timer = 0
      if Upgrade.player_special[3]
        x = math.random Screen_Size.border[1], Screen_Size.border[3]
        y = math.random Screen_Size.border[2], Screen_Size.border[4]
        bomb = PlayerBomb x, y
        Driver\addObject bomb, EntityTypes.bomb
    for k, bullet_position in pairs @globes
      bullet_position\rotate dt * 1.25 * math.pi
    if @elapsed >= @turret_cooldown
      @can_place = true
    @speed_boost = 0
    if Driver.objects[EntityTypes.enemy]
      for k, v in pairs Driver.objects[EntityTypes.enemy]
        enemy = v\getHitBox!
        player = @getHitBox!
        player.radius += @attack_range + @range_boost
        if enemy\contains player
          bullet_position = Vector 0, 0
          --if SHOW_RANGE
          --  @globe_index += 1
          --  if @globe_index > #@globes
          --    @globe_index = 1
          --  bullet_position = @globes[@globe_index]
          bullet = PlayerBullet bullet_position.x + @position.x, bullet_position.y + @position.y, v, @damage
          Driver\addObject bullet, EntityTypes.bullet
          if Upgrade.player_special[4]
            @speed_boost += @max_speed / 5
    if Driver.objects[EntityTypes.goal]
      for k, v in pairs Driver.objects[EntityTypes.goal]
        if v.goal_type == GoalTypes.attack
          goal = v\getHitBox!
          player = @getHitBox!
          player.radius += @attack_range + @range_boost
          if goal\contains player
            bullet_position = Vector 0, 0
            --if SHOW_RANGE
            --  @globe_index += 1
            --  if @globe_index > #@globes
            --    @globe_index = 1
            --  bullet_position = @globes[@globe_index]
            bullet = PlayerBullet bullet_position.x + @position.x, bullet_position.y + @position.y, v, @damage
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
    boosted = false
    for k, v in pairs @turret
      if Upgrade.player_special[2]
        turret = v\getHitBox!
        player = @getHitBox!
        player.radius += v.range
        if turret\contains player
          boosted = true
      if not v.alive
        @num_turrets -= 1
        @turret[k] = nil
    if boosted
      @range_boost = @attack_range
    else
      @range_boost = 0

  draw: =>
    if not @alive return
    if DEBUGGING
      love.graphics.push "all"
      love.graphics.setColor 0, 0, 255, 100
      player = @getHitBox!
      love.graphics.circle "fill", @position.x, @position.y, @attack_range + player.radius + @range_boost, 360
      love.graphics.pop!
    super!

    message = " Turret CD  "
    Renderer\drawHUDMessage message, (9 * Scale.width), Screen_Size.height - (52 * Scale.height), @font
    x_start = (9 * Scale.width) + @font\getWidth message

    love.graphics.setColor 255, 255, 255, 255
    love.graphics.rectangle "fill", x_start, love.graphics.getHeight! - (52 * Scale.height), 202 * Scale.width, 43 * Scale.height

    remaining = clamp @turret_cooldown - @elapsed, 0, @turret_cooldown
    remaining = math.floor remaining
    love.graphics.setColor 0, 0, 0, 255
    love.graphics.rectangle "fill", x_start + Scale.width, love.graphics.getHeight! - (51 * Scale.height), 200 * Scale.width, 20 * Scale.height
    love.graphics.setColor 0, 0, 255, 255
    ratio = 1 - (remaining / @turret_cooldown)
    if remaining == 0 or @can_place
      ratio = 1
    love.graphics.rectangle "fill", x_start + (4 * Scale.width), love.graphics.getHeight! - (48 * Scale.height), 194 * ratio * Scale.width, 14 * Scale.height

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

    message = " Turret HP  "
    Renderer\drawHUDMessage message, (9 * Scale.width), Screen_Size.height - (30 * Scale.height), @font

    love.graphics.setColor 0, 0, 0, 255
    love.graphics.rectangle "fill", x_start + Scale.width, love.graphics.getHeight! - (30 * Scale.height), 200 * Scale.width, 20 * Scale.height
    love.graphics.setColor 0, 255, 0, 255
    love.graphics.rectangle "fill", x_start + (4 * Scale.width), love.graphics.getHeight! - (27 * Scale.height), 194 * ratio * Scale.width, 14 * Scale.height

    love.graphics.setColor 0, 0, 0, 255
    love.graphics.rectangle "fill", (love.graphics.getWidth! / 2) - (200 * Scale.width), love.graphics.getHeight! - (30 * Scale.height), 400 * Scale.width, 20 * Scale.height
    love.graphics.setColor 255, 0, 0, 255
    ratio = @health / @max_health
    love.graphics.rectangle "fill", (love.graphics.getWidth! / 2) - (197 * Scale.width), love.graphics.getHeight! - (27 * Scale.height), 394 * ratio * Scale.width, 14 * Scale.height

    Renderer\drawAlignedMessage "Player Health", Screen_Size.height - (47 * Scale.height), nil, @font

    if SHOW_RANGE
      love.graphics.setColor 0, 255, 255, 255
      for k, bullet_position in pairs @globes
        boost = Vector @range_boost, 0
        angle = bullet_position\getAngle!
        boost\rotate angle
        x = @position.x + bullet_position.x + boost.x
        y = @position.y + bullet_position.y + boost.y
        love.graphics.circle "fill", x, y, 8 * Scale.diag, 360

  kill: =>
    super\kill!
    Driver.game_over!
    --player = Player @position.x, @position.y
    --Driver\addObject player, EntityTypes.player
