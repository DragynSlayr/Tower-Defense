export class BombActive extends ActiveItem
  new: (x, y) =>
    sprite = Sprite "background/bomb.tga", 32, 32, 1, 1.75
    effect = (player) =>
      bomb = Bomb player.position.x, player.position.y
      Driver\addObject bomb, EntityTypes.background
    super x, y, sprite, 15, effect
    @name = "Bomb"
    @description = "Places a powerful bomb"
