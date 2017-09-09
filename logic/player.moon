export class Player extends GameObject
  new: (x, y) =>
    sprite = Sprite "player/test.tga", 16, 16, 0.29, 4
    super x, y, sprite
    @sprite\setRotationSpeed -math.pi / 2

    @max_health      = Stats.player[1]
    @attack_range    = Stats.player[2]
    @damage          = Stats.player[3]
    @max_speed       = Stats.player[4]
    @turret_cooldown = Stats.turret[4]
    @attack_speed    = Base_Stats.player[5]
    @health = @max_health
    @repair_range = 30 * Scale.diag
    @keys_pushed = 0
    @hit = false
    @attack_timer = 0
    @lives = 1

    @id = EntityTypes.player
    @draw_health = false

    @font = Renderer\newFont 20

    @can_place = true
    @max_turrets = 1
    if Upgrade.turret_special[1]
      @max_turrets = 2
    @num_turrets = 0
    @turret = {}

    @range_boost   = 0
    @speed_boost   = 0
    @missile_timer    = 0
    @max_missile_time = 5.5
    @speed_range   = @sprite\getBounds!.radius + (150 * Scale.diag)
    @turret_count  = @max_turrets
    @charged       = true

    @globes = {}
    @globe_index = 1

    bounds = @getHitBox!
    width = bounds.radius + @attack_range
    num = 5
    for i = 1, num
      angle = ((math.pi * 2) / num) * i
      vec = Vector width, 0
      vec\rotate angle
      @globes[i] = Vector vec.x, vec.y

    @equipped_items = {}

    @setArmor 0, @max_health

    @knocking_back = false
    @knock_back_sprite = Sprite "projectile/knockback.tga", 26, 20, 1, 0.75

    @movement_blocked = false
    @lock_sprite = Sprite "effect/lock.tga", 32, 32, 1, 1.75
    @draw_lock = true

    sound = Sound "turret_repair.ogg", 0.50, false, 0.33, true
    @repair_sound = MusicPlayer\add sound

    sound = Sound "turret_place.ogg", 0.75, false, 0.5, true
    @place_sound = MusicPlayer\add sound

    @show_stats = true
    @is_clone = false

  getStats: =>
    stats = {}
    stats[1] = @max_health
    stats[2] = @attack_range
    stats[3] = @damage
    stats[4] = @max_speed
    stats[5] = @attack_speed
    return stats

  onCollide: (object) =>
    if not @alive return
    if object.id == EntityTypes.item
      object\pickup @
      return
    if not @shielded
      damage = object.damage
      if @slagged
        damage *= 2
      if @armored
        if object.id == EntityTypes.enemy and object.enemyType == EnemyTypes.turret
          damage /= 2
        @armor -= damage
        if @armor <= 0
          @health += @armor
        @armored = @armor > 0
      else
        damage = object.damage
        if object.id == EntityTypes.enemy and object.enemyType == EnemyTypes.turret
          damage /= 2
        @health -= damage
        @hit = true
      if object.slagging
        @slagged = true
    @health = clamp @health, 0, @max_health
    @armor = clamp @armor, 0, @max_armor

  keypressed: (key) =>
    if not @alive return

    if not @movement_blocked
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

    if not @is_clone
      if key == "q"
        for k, v in pairs @equipped_items
          v\use!
      elseif key == "e"
        if @num_turrets != @max_turrets
          if @can_place
            @show_turret = not @show_turret
        else
          if Upgrade.turret_special[4]
            for k, v in pairs @turret
              turret = v\getAttackHitBox!
              player = @getHitBox!
              player.radius += @repair_range
              if turret\contains player
                @num_turrets -= 1
                @turret[k] = nil
                Driver\removeObject v, false
      elseif key == "space"
        if @show_turret
          turret = BasicTurret @position.x, @position.y, @turret_cooldown
          if @num_turrets < @max_turrets
            Driver\addObject turret, EntityTypes.turret
            MusicPlayer\play @place_sound
            @num_turrets += 1
            @turret[#@turret + 1] = turret
            @show_turret = false
            @turret_count -= 1
            if @turret_count == 0
              @can_place = false
            @charged = false
        elseif @turret
          for k, v in pairs @turret
            turret = v\getAttackHitBox!
            player = @getHitBox!
            player.radius += @repair_range
            if turret\contains player
              if v.health < v.max_health
                MusicPlayer\play @repair_sound
              v.health += 1
              v.health = clamp v.health, 0, v.max_health
      elseif key == "z"
        export SHOW_RANGE = not SHOW_RANGE

  keyreleased: (key) =>
    if not @alive return

    if not @movement_blocked
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

    if @keys_pushed == 0 or @movement_blocked
      @speed = Vector 0, 0
      super dt
    else
      start = Vector @speed\getComponents!
      if @speed\getLength! > @max_speed
        @speed = @speed\multiply 1 / (math.sqrt 2)
      boost = Vector @speed_boost, 0
      angle = @speed\getAngle!
      boost\rotate angle
      @speed\add boost
      super dt
      @speed = start

    @lock_sprite\update dt

    for k, i in pairs @equipped_items
      i\update dt

    @missile_timer += dt
    if @missile_timer >= @max_missile_time
      @missile_timer = 0
      if Upgrade.player_special[3]
        --x = math.random Screen_Size.border[1], Screen_Size.border[3]
        --y = math.random Screen_Size.border[2], Screen_Size.border[4]
        --bomb = Bomb x, y
        missile = Missile @position.x, @position.y
        Driver\addObject missile, EntityTypes.bullet

    for k, bullet_position in pairs @globes
      bullet_position\rotate dt * 1.25 * math.pi

    if @turret_count ~= @max_turrets
      if @elapsed >= @turret_cooldown
        @elapsed = 0
        @turret_count = clamp @turret_count + 1, 0, @max_turrets
        @can_place = true
        @charged = false
    else
      @elapsed = 0
      @charged = true

    @speed_boost = 0
    @attack_timer += dt
    attacked = false
    if @attack_timer >= @attack_speed / (Upgrade.player_stats[5] + 1)
      filters = {EntityTypes.enemy, EntityTypes.boss}
      for k2, filter in pairs filters
        if Driver.objects[filter]
          for k, v in pairs Driver.objects[filter]
            enemy = v\getHitBox!
            player = @getHitBox!
            player.radius += @attack_range + @range_boost
            if enemy\contains player
              if Upgrade.player_special[4]
                @speed_boost += @max_speed / 4

              bullet = PlayerBullet @position.x, @position.y, v, @damage
              if @knocking_back
                bullet.sprite = @knock_back_sprite
                bullet.knockback = true
              Driver\addObject bullet, EntityTypes.bullet
              attacked = true

      if Driver.objects[EntityTypes.goal]
        for k, v in pairs Driver.objects[EntityTypes.goal]
          if v.goal_type == GoalTypes.attack
            goal = v\getHitBox!
            player = @getHitBox!
            player.radius += @attack_range + @range_boost
            if goal\contains player
              bullet = PlayerBullet @position.x, @position.y, v, @damage
              Driver\addObject bullet, EntityTypes.bullet
              attacked = true
          else if v.goal_type == GoalTypes.find
            goal = v\getHitBox!
            player = @getHitBox!
            player.radius *= 1.25
            if goal\contains player
              v\onCollide @
              attacked = true

    if attacked
      @attack_timer = 0
    @speed_boost = math.min @speed_boost, @max_speed

    if Driver.objects[EntityTypes.goal]
      for k, v in pairs Driver.objects[EntityTypes.goal]
        if v.goal_type == GoalTypes.capture
          goal = v\getHitBox!
          player = @getHitBox!
          player.radius += @repair_range
          if goal\contains player
            v\onCollide @

    if @show_turret
      turret = BasicTurret @position.x, @position.y
      Renderer\enqueue turret\drawFaded

    boosted = false
    for k, v in pairs @turret
      if Upgrade.player_special[2]
        turret = v\getAttackHitBox!
        player = @getHitBox!
        player.radius += v.range / 5
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
    for k, i in pairs @equipped_items
      i\draw!
    if DEBUGGING
      love.graphics.push "all"
      love.graphics.setColor 0, 0, 255, 100
      player = @getHitBox!
      love.graphics.circle "fill", @position.x, @position.y, @attack_range + player.radius + @range_boost, 360
      love.graphics.setColor 0, 255, 0, 100
      love.graphics.circle "fill", @position.x, @position.y, @speed_range, 360
      love.graphics.pop!
    super!
    if @movement_blocked and @draw_lock
      @lock_sprite\draw @position.x, @position.y

    if @show_stats
      love.graphics.setColor 0, 0, 0, 255
      love.graphics.setFont @font
      message = "Turret Cooldown"
      love.graphics.printf message, 9 * Scale.width, Screen_Size.height - (47 * Scale.height) - @font\getHeight! / 2, 205 * Scale.width, "center"

      x_start = (9 * Scale.width)

      remaining = clamp @elapsed, 0, @turret_cooldown--@turret_timer, 0, @turret_max
      love.graphics.setColor 0, 0, 0, 255
      love.graphics.rectangle "fill", x_start + Scale.width, love.graphics.getHeight! - (30 * Scale.height), 200 * Scale.width, 20 * Scale.height
      love.graphics.setColor 0, 0, 255, 255
      ratio = remaining / @turret_cooldown--@turret_max
      if @charged
        ratio = 1
      love.graphics.rectangle "fill", x_start + (4 * Scale.width), love.graphics.getHeight! - (27 * Scale.height), 194 * ratio * Scale.width, 14 * Scale.height

      message = @turret_count .. "/" .. @max_turrets
      Renderer\drawHUDMessage message, (x_start + 205) * Scale.width, Screen_Size.height - (30 * Scale.height), @font

      love.graphics.setColor 0, 0, 0, 255
      love.graphics.rectangle "fill", (love.graphics.getWidth! / 2) - (200 * Scale.width), love.graphics.getHeight! - (30 * Scale.height), 400 * Scale.width, 20 * Scale.height
      love.graphics.setColor 255, 0, 0, 255
      ratio = @health / @max_health
      love.graphics.rectangle "fill", (love.graphics.getWidth! / 2) - (197 * Scale.width), love.graphics.getHeight! - (27 * Scale.height), 394 * ratio * Scale.width, 14 * Scale.height
      if @armored
        love.graphics.setColor 0, 127, 255, 255
        ratio = @armor / @max_armor
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
    @lives -= 1
    if @lives <= 0
      super!
      Driver.game_over!
    else
      @health = @max_health
      @shielded = true
      Driver\addObject @, EntityTypes.player
