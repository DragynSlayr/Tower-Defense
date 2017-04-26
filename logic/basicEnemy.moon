export class BasicEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/tracker.tga", 25, 25, 1, 2
    super x, y, sprite, Player

  kill: =>
    super\kill!
    for i = 1, 2
      x = math.random love.graphics.getWidth!
      y = math.random love.graphics.getHeight!
      enemy = BasicEnemy x, y
      Driver\addObject enemy, EntityTypes.enemy
