export class BasicTurret extends Turret
  new: (x, y, cd) =>
    super x, y, Stats.turret[2], (Sprite "turret/turret.tga", 34, 16, 2, 2.5), cd
