export class BasicTurret extends Turret
  new: (x, y) =>
    super x, y, 250, Sprite "turret.tga", 34, 16, 2, 2.5
