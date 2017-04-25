export class BasicTurret extends Turret
  new: (x, y) =>
    super x, y, 250, Sprite "boss/shield.tga", 27, 26, 1, 2.5
