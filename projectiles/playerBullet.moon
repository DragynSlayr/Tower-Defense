export class PlayerBullet extends Bullet
  new: (x, y, target) =>
    super x, y, target
    @sprite = Sprite "enemy/bullet.tga", 26, 20, 1, 0.5
