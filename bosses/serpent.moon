export class BossSerpent extends Boss
  new: (x, y) =>
    sprite = Sprite "boss/serpent/head.tga", 56, 84, 1, 1
    super x, y, sprite
    @bossType = BossTypes.serpent
    @score_value = 1000
    @exp_given = @score_value + (@score_value * 0.25 * Objectives\getLevel!)

    @health = 1000
    @max_health = @health
    @max_speed = 250
    @speed_multiplier = @max_speed
    @damage = 0.02

    @ai_phase = 1
    @ai_time = 0

    @body_sprite = Sprite "boss/serpent/body.tga", 48, 48, 1, 1
    @tail_sprite = Sprite "boss/serpent/tail.tga", 48, 96, 1, 1

    @target = Driver.objects[EntityTypes.player][1]

    @parts = {}
    @num_parts = 250

    angle = (2 * math.pi) / (@num_parts + 1)

    for i = 1, @num_parts
      part = {}
      v = Vector 0, -1
      v\rotate ((i - 1) * angle)
      x, y = (v\multiply Screen_Size.height * 0.33)\getComponents!
      x += Screen_Size.half_width
      y += Screen_Size.half_height
      if i == 1
        @position = Vector x, y
      part.position = Vector x, y
      if i > 1
        part.following = @parts[i - 1]
      table.insert @parts, part

    @parts[1].following = @

  update: (dt) =>
    @speed = Vector @target.position.x - @position.x, @target.position.y - @position.y
    @speed\toUnitVector!
    @speed = @speed\multiply @speed_multiplier
    @sprite.rotation = @speed\getAngle! + math.pi
    super dt

    @ai_time += dt

    for i = 1, @num_parts
      x = @parts[i].following.position.x - @parts[i].position.x
      y = @parts[i].following.position.y - @parts[i].position.y
      speed = Vector x, y, true
      @parts[i].position\add (speed\multiply (dt * @speed_multiplier))

  draw: =>
    for i = @num_parts, 1, -1
      part = @parts[i]
      if i >= (@num_parts * 0.95)
        @tail_sprite.rotation = (part.position\getAngleBetween part.following.position) + (math.pi / 2)
        @tail_sprite\draw part.position\getComponents!
      else
        @body_sprite.rotation = @sprite.rotation + math.pi
        @body_sprite\draw part.position\getComponents!
    super!
