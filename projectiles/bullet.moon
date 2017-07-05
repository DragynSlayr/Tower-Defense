export class Bullet extends HomingProjectile
  new: (x, y, target, damage) =>
    sprite = Sprite "projectile/bullet_anim.tga", 32, 16, 0.02, 0.75
    super x, y, target, sprite
    @damage = damage
