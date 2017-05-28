export class PlayerBullet extends HomingProjectile
  new: (x, y, target, damage) =>
    super x, y, target
    @sprite = Sprite "enemy/bullet.tga", 26, 20, 1, 0.5
    @damage = damage
