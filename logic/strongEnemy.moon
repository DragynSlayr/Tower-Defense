export class StrongEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/bullet.tga", 26, 20, 1, 2
    super x, y, sprite
    @damage = 2
    @health = 8
    @max_health = @health
    @max_speed = 100
    @speed_multiplier = 100
