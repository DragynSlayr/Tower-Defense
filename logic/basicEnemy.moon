export class BasicEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/tracker.tga", 25, 25, 1, 2
    super x, y, sprite, Player
