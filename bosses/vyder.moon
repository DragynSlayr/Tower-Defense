export class BossVyder extends Boss
  new: (x, y) =>
    sprite = Sprite "boss/fox_bat/fox_bat.tga", 729, 960, 1, 1
    sprite\setScale 0.25, 0.25
    super x, y, sprite
    @bossType = BossTypes.vyder
    level = ((Objectives\getLevel! + 1) / (#Objectives.modes + 1)) - 1
    @health = 1000 + (1000 * level)
    @max_health = @health
    @speed_multiplier = 200 + (100 * level)
    @boost_multiplier = 3
    @chase_time = 0
    @damage = (5 / 60) + ((10 / 60) * level)
    @attack_range = 100 * Scale.diag
    @contact_damage = true

    sprite = Sprite "poison.tga", 64, 64, 1, 1.75
    @trail = ParticleEmitter @position.x, @position.y, 0.2, 3, @
    --@trail = ParticleTrail @position.x, @position.y, sprite, @
    --@trail.life_time = 3
    @trail.sprite = sprite
    @trail.particle_type = ParticleTypes.poison
    @trail.moving_particles = false

    @ai_phase = 1
    @ai_time = 0
    @target_position = Driver\getRandomPosition!

    splitted = split @normal_sprite.name, "."
    name = splitted[1] .. "Action." .. splitted[2]
    height, width, _, scale = @normal_sprite\getProperties!

    @action_sprite = ActionSprite name, height, width, 0.5, 1, @, () =>
      @parent.ai_phase = 1
      @parent.ai_time = 0
      @parent.target_position = Driver\getRandomPosition!

    x_scale = @normal_sprite.scaled_width / (@normal_sprite.width * Scale.width)
    y_scale = @normal_sprite.scaled_height / (@normal_sprite.height * Scale.height)

    @action_sprite\setScale x_scale, y_scale

  getHitBox: =>
    -- Get the radius of this Sprite as the minimum of height and width
    radius = math.min @sprite.scaled_height / 2, @sprite.scaled_width / 2
    radius *= 0.75

    -- Return a new Circle at this x and y with the radius
    return Circle @position.x, @position.y + (25 * Scale.height), radius

  update: (dt) =>
    @ai_time += dt
    switch @ai_phase
      when 1
        @speed = Vector @target_position.x - @position.x, @target_position.y - @position.y
        dist = @speed\getLength!
        @speed\toUnitVector!
        @speed = @speed\multiply @speed_multiplier
        super dt
        @chase_time += dt
        if dist <= @getHitBox!.radius or @chase_time >= 3
          @chase_time = 0
          @target_position = Driver\getRandomPosition!
        if @ai_time >= 10
          @ai_time = 0
          @ai_phase += 1
      when 2
        targets = {}
        if Driver.objects[EntityTypes.player]
          targets = concatTables targets, Driver.objects[EntityTypes.player]
        --if Driver.objects[EntityTypes.turret]
          --targets = concatTables targets, Driver.objects[EntityTypes.turret]
        target = pick targets
        @target_position = target.position
        @ai_time = 0
        @ai_phase += 1
      when 3
        @speed = Vector @target_position.x - @position.x, @target_position.y - @position.y
        dist = @speed\getLength!
        @speed\toUnitVector!
        @speed = @speed\multiply @speed_multiplier * @boost_multiplier
        super dt
        @chase_time += dt
        if dist < @getHitBox!.radius + (@attack_range / 2) or @ai_time >= 1
          @ai_time = 0
          @ai_phase += 1
      when 4
        @speed = Vector 0, 0
        @sprite = @action_sprite
        @ai_time = 0
        @ai_phase += 1
      when 5
        super dt
        if Driver.objects[EntityTypes.player]
          for k, v in pairs Driver.objects[EntityTypes.player]
            player = v\getHitBox!
            boss = @getHitBox!
            boss.radius += @attack_range
            if player\contains boss
              v\onCollide @
        if Driver.objects[EntityTypes.turret]
          for k, v in pairs Driver.objects[EntityTypes.turret]
            turret = v\getAttackHitBox!
            boss = @getHitBox!
            boss.radius += @attack_range
            if turret\contains boss
              v\onCollide @

  draw: =>
    if DEBUGGING
      love.graphics.push "all"
      love.graphics.setShader Driver.shader
      love.graphics.setColor 255, 0, 0, 255
      love.graphics.circle "fill", @target_position.x, @target_position.y, 3, 360
      love.graphics.setShader!
      love.graphics.pop!
    super!
