export class BasicTurret extends Turret
  new: (x, y) =>
    super x, y, Stats.turret[2], Sprite "turret.tga", 34, 16, 2, 2.5
