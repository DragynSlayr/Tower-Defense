export class Bullet extends Enemy
  new: (x, y, target) =>
    sprite = Sprite "beam.tga", 16, 8, 1, 1.5
    super x, y, sprite, target
    @attack_range = 15
    @damage = 1 / 10
    @id = EntityTypes.bullet
    @draw_health = false

  update: (dt) =>
    if not @alive return
    if not @target
      @kill!
    @sprite\update dt

    @speed = Vector @target.position.x - @position.x, @target.position.y - @position.y
    @speed\toUnitVector!
    @speed = @speed\multiply 1000

    @position\add @speed\multiply dt

    vec = Vector 0, 0
    @sprite.rotation = @speed\getAngleBetween vec

    target = @target\getHitBox!
    bullet = @getHitBox!
    target.radius += bullet.radius + @attack_range
    if target\contains bullet.center
      @target\onCollide @
      @kill!
