export class BossVyder extends Boss
  new: (x, y) =>
    sprite = Sprite "boss/fox_bat/fox_bat.tga", 729, 960, 1, 1
    sprite\setScale 0.25, 0.25
    super x, y, sprite
    @bossType = BossTypes.vyder
    @health = 300
    @max_health = @health
    @speed_multiplier = 200

    sprite = Sprite "poison.tga", 64, 64, 1, 2
    @trail = ParticleTrail @position.x, @position.y, sprite, @
    @trail.life_time = 3

    @ai = {}
    @ai.phase = 1
    @target_position = Driver\getRandomPosition!

  getHitBox: =>
    -- Get the radius of this Sprite as the minimum of height and width
    radius = math.min @sprite.scaled_height / 2, @sprite.scaled_width / 2
    radius *= 0.75

    -- Return a new Circle at this x and y with the radius
    return Circle @position.x, @position.y + (25 * Scale.height), radius

  update: (dt) =>
    @speed = Vector @target_position.x - @position.x, @target_position.y - @position.y
    dist = @speed\getLength!
    @speed\toUnitVector!
    @speed = @speed\multiply @speed_multiplier
    super dt
    if dist <= @getHitBox!.radius
      @target_position = Driver\getRandomPosition!

  draw: =>
    super!
    love.graphics.push "all"
    love.graphics.setShader Driver.shader
    love.graphics.setColor 255, 0, 0, 255
    love.graphics.circle "fill", @target_position.x, @target_position.y, 3, 360
    love.graphics.setShader!
    love.graphics.pop!
