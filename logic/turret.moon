export class Turret extends GameObject
  new: (x, y, range, sprite) =>
    super x, y, sprite, 0, 0
    @range = @sprite\getBounds!.radius + range

  update: (dt) =>
    return

  draw: =>
    if DEBUGGING
      love.graphics.push "all"
      love.graphics.setColor 255, 0, 0, 255
      love.graphics.circle "fill", @position.x, @position.y, @range, 25
      love.graphics.pop!
    super!

  drawFaded: =>
    love.graphics.push "all"
    r, g, b, a = love.graphics.getColor!
    love.graphics.setColor r, g, b, 50
    love.graphics.circle "fill", @position.x, @position.y, @range, 25
    @sprite\draw @position.x, @position.y
    love.graphics.pop!

  isOnScreen: =>
    circle = @getHitBox!
    x, y = circle.center\getComponents!
    radius = @range
    xOn = x - radius >= 0 and x + radius <= love.graphics.getWidth!
    yOn = y - radius >= 0 and y + radius <= love.graphics.getHeight!
    return xOn and yOn
