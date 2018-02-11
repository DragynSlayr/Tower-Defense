export class Player extends GameObject
  new: (x, y) =>
    sprite = Sprite "player/test.tga", 16, 16, 2, 4
    super x, y, sprite
    @sprite\setRotationSpeed -math.pi / 2

    @colliders = {EntityTypes.enemy, EntityTypes.goal, EntityTypes.boss}

    @max_health      = Stats.player[1]
    @attack_range    = Stats.player[2]
    @damage          = Stats.player[3]
    @max_speed       = Stats.player[4]
    @turret_cooldown = Stats.turret[4]
    @attack_speed    = Stats.player[5]
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
    @num_turrets = 0
    @turret = {}

    @range_boost   = 0
    @speed_boost   = 0
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

    @level = 1
    @exp = 0
    @exp_lerp = @exp
    @next_exp = @calcExp (@level + 1)

    @can_shoot = true
    @bullet_speed = @max_speed * 1.25

  calcExp: (level) =>
    return (6 * level * level) + 673

  getStats: =>
    stats = {}
    stats[1] = @max_health
    stats[2] = @attack_range
    stats[3] = @damage
    stats[4] = @max_speed
    stats[5] = @attack_speed
    return stats

  hasItem: (itemType) =>
    for k, v in pairs @equipped_items
      if (v.__class == itemType)
        return true
    return false

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
    if not @alive or @is_clone return

    if not @movement_blocked
      @last_pressed = key
      if key == Controls.keys.MOVE_LEFT
        @speed.x -= @max_speed
      elseif key == Controls.keys.MOVE_RIGHT
        @speed.x += @max_speed
      elseif key == Controls.keys.MOVE_UP
        @speed.y -= @max_speed
      elseif key == Controls.keys.MOVE_DOWN
        @speed.y += @max_speed
      for k, v in pairs {Controls.keys.MOVE_LEFT, Controls.keys.MOVE_RIGHT, Controls.keys.MOVE_UP, Controls.keys.MOVE_DOWN}
        if key == v
          @keys_pushed += 1

    if key == Controls.keys.USE_ITEM
      for k, v in pairs @equipped_items
        v\use!
    elseif key == Controls.keys.TOGGLE_TURRET
      if @can_place
        @show_turret = not @show_turret
    elseif key == Controls.keys.USE_TURRET
      if @show_turret
        turret = BasicTurret @position.x, @position.y, @turret_cooldown
        Driver\addObject turret, EntityTypes.turret
        MusicPlayer\play @place_sound

        if @num_turrets < @max_turrets
          @num_turrets += 1
          @turret[#@turret + 1] = turret
        elseif @num_turrets == @max_turrets
          Driver\removeObject @turret[1]
          for i = 1, @num_turrets - 1
            @turret[i] = @turret[i + 1]
          @turret[#@turret] = turret
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
    elseif key == Controls.keys.SHOW_RANGE
      export SHOW_RANGE = not SHOW_RANGE

  keyreleased: (key) =>
    if not @alive return

    if not @movement_blocked
      @last_released = key
      if @keys_pushed > 0
        if key == Controls.keys.MOVE_LEFT
          @speed.x += @max_speed
        elseif key == Controls.keys.MOVE_RIGHT
          @speed.x -= @max_speed
        elseif key == Controls.keys.MOVE_UP
          @speed.y += @max_speed
        elseif key == Controls.keys.MOVE_DOWN
          @speed.y -= @max_speed
        for k, v in pairs {Controls.keys.MOVE_LEFT, Controls.keys.MOVE_RIGHT, Controls.keys.MOVE_UP, Controls.keys.MOVE_DOWN}
          if key == v
            @keys_pushed -= 1

  update: (dt) =>
    if not @alive return

    for k, i in pairs @equipped_items
      i\update dt

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

    for k, v in pairs @turret
      if not v.alive
        @num_turrets -= 1
        @turret[k] = nil

    @speed_boost = 0
    @attack_timer += dt
    attacked = false
    filters = {EntityTypes.enemy, EntityTypes.boss}
    if Driver.objects[EntityTypes.goal]
      for k, v in pairs Driver.objects[EntityTypes.goal]
        if v.goal_type == GoalTypes.attack
          table.insert filters, EntityTypes.goal
          break
    if @attack_timer >= @attack_speed
      bullet_speed = Vector 0, 0
      if love.keyboard.isDown Controls.keys.SHOOT_LEFT
        bullet_speed\add (Vector -@bullet_speed, 0)
      if love.keyboard.isDown Controls.keys.SHOOT_RIGHT
        bullet_speed\add (Vector @bullet_speed, 0)
      if love.keyboard.isDown Controls.keys.SHOOT_UP
        bullet_speed\add (Vector 0, -@bullet_speed)
      if love.keyboard.isDown Controls.keys.SHOOT_DOWN
        bullet_speed\add (Vector 0, @bullet_speed)
      if bullet_speed\getLength! > 0
        bullet = FilteredBullet @position.x, @position.y, @damage, bullet_speed, filters
        bullet.max_dist = (@getHitBox!.radius + (2 * (@attack_range + @range_boost)))-- * (math.max 0.5, ratio)
        if @knocking_back
          bullet.sprite = @knock_back_sprite
          bullet.knockback = true
        if @can_shoot
          Driver\addObject bullet, EntityTypes.bullet
          attacked = true

    if attacked
      @attack_timer = 0

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

    while @exp >= @next_exp
      @exp -= @next_exp
      @level += 1
      Upgrade\addPoint 1
      @next_exp = @calcExp @level
    @exp_lerp = math.min @exp_lerp + (120 * dt), @exp

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

      remaining = clamp @elapsed, 0, @turret_cooldown
      love.graphics.setColor 0, 0, 0, 255
      love.graphics.rectangle "fill", x_start + Scale.width, Screen_Size.height - (30 * Scale.height), 200 * Scale.width, 20 * Scale.height
      love.graphics.setColor 0, 0, 255, 255
      ratio = remaining / @turret_cooldown--@turret_max
      if @charged
        ratio = 1
      love.graphics.rectangle "fill", x_start + (4 * Scale.width), Screen_Size.height - (27 * Scale.height), 194 * ratio * Scale.width, 14 * Scale.height

      message = @turret_count .. "/" .. @max_turrets
      Renderer\drawHUDMessage message, (x_start + 210) * Scale.width, Screen_Size.height - (30 * Scale.height), @font

      y_start = Screen_Size.height - (60 * Scale.height)

      love.graphics.setColor 0, 0, 0, 255
      love.graphics.rectangle "fill", Screen_Size.half_width - (200 * Scale.width), y_start, 400 * Scale.width, 20 * Scale.height
      love.graphics.setColor 255, 0, 0, 255
      ratio = @health / @max_health
      love.graphics.rectangle "fill", Screen_Size.half_width - (197 * Scale.width), y_start + (3 * Scale.height), 394 * ratio * Scale.width, 14 * Scale.height
      if @armored
        love.graphics.setColor 0, 127, 255, 255
        ratio = @armor / @max_armor
        love.graphics.rectangle "fill", Screen_Size.half_width - (197 * Scale.width), y_start + (3 * Scale.height), 394 * ratio * Scale.width, 14 * Scale.height

      love.graphics.setColor 0, 0, 0, 255
      love.graphics.rectangle "fill", Screen_Size.half_width - (200 * Scale.width), y_start + (32 * Scale.height), 400 * Scale.width, 20 * Scale.height
      love.graphics.setColor 255, 235, 4, 255
      next_exp = @calcExp (@level + 1)
      ratio = @exp_lerp / next_exp
      love.graphics.rectangle "fill", Screen_Size.half_width - (197 * Scale.width), y_start + (35 * Scale.height), 394 * ratio * Scale.width, 14 * Scale.height

      love.graphics.setFont @font
      love.graphics.setColor 0, 0, 0, 255
      x_offset = 325 * Scale.width

      limit = (@font\getWidth ".") * 17

      y = y_start + (1.5 * Scale.height)
      love.graphics.printf "Health", Screen_Size.half_width - x_offset, y, limit, "left"
      health = string.format "%.2f/%.2f HP", @health, @max_health
      love.graphics.printf health, Screen_Size.half_width + (x_offset * 0.75), y, limit, "left"

      y = y_start + (33.5 * Scale.height)
      love.graphics.printf "Level: " .. @level, Screen_Size.half_width - x_offset, y, limit, "left"
      love.graphics.printf (math.floor @exp) .. "/" .. (@calcExp (@level + 1)) .. " XP", Screen_Size.half_width + (x_offset * 0.75), y, limit, "left"


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
