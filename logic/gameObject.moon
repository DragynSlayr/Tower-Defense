export class GameObject
  new: (x, y, sprite, x_speed = 0, y_speed = 0, ai = nil) =>
    @position = Vector x, y
    @speed = Vector x_speed, y_speed
    @sprite = sprite
    @ai = ai
    @elapsed = 0

  getHitBox: =>
    return @sprite\getBounds @position.x, @position.y

  onCollide: (object) =>
    print @__name .. " hit " .. object.__name

  update: (dt) =>
    @sprite\update dt
    @elapsed += dt
    if @ai
      @ai dt
    else
      @position\add @speed\multiply dt
    radius = @getHitBox!.radius
    @position.x = MathHelper\clamp @position.x, radius, love.graphics.getWidth! - radius
    @position.y = MathHelper\clamp @position.y, radius, love.graphics.getHeight! - radius

  draw: =>
    @sprite\draw @position.x, @position.y

  isOnScreen: =>
    circle = @getHitBox!
    x, y = circle.center\getComponents!
    radius = circle.radius
    xOn = x - radius >= 0 and x + radius <= love.graphics.getWidth!
    yOn = y - radius >= 0 and y + radius <= love.graphics.getHeight!
    return xOn and yOn
