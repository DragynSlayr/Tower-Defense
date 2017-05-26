export class Bullet extends HomingProjectile
  new: (x, y, target) =>
    sprite = Sprite "beam.tga", 16, 8, 1, 1.5
    super x, y, target, sprite
    @damage = 0.075
