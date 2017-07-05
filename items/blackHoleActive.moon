export class BlackHoleActive extends ActiveItem
  new: (x, y) =>
    sprite = Sprite "background/blackhole.tga", 32, 32, 1, 1.75
    effect = (player) =>
      hole = BlackHole player.position.x, player.position.y
      Driver\addObject hole, EntityTypes.background
    super x, y, sprite, 20, effect
    @name = "Singularity"
    @description = "Places a black hole that sucks in enemies"
