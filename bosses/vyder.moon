export class BossVyder extends Boss
  new: (x, y) =>
    sprite = Sprite "boss/fox_bat/fox_bat.tga", 729, 960, 1, 1
    sprite\setScale 0.25, 0.25
    super x, y, sprite
    @bossType = BossTypes.vyder
    @health = 300
    @max_health = @health

  getHitBox: =>
    -- Get the radius of this Sprite as the minimum of height and width
    radius = math.min @sprite.scaled_height / 2, @sprite.scaled_width / 2

    radius *= 0.75

    -- Return a new Circle at this x and y with the radius
    return Circle @position.x, @position.y + (25 * Scale.height), radius
