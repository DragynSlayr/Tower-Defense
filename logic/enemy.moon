export class Enemy extends GameObject
  new: (x, y, sprite, target) =>
    super x, y, sprite
    @target = target

  update: (dt) =>
    @speed = Vector @target.position.x - @position.x, @target.position.y - @position.y
    super dt
    vec = Vector 0, 0
    @sprite.rotation = @speed\getAngleBetween vec
