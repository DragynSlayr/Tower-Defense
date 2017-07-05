export class BombPassive extends PassiveItem
  new: (x, y) =>
    sprite = Sprite "item/bomb.tga", 32, 32, 1, 1.75
    effect = (player) =>
      x = math.random Screen_Size.border[1], Screen_Size.border[3]
      y = math.random Screen_Size.border[2], Screen_Size.border[4]
      bomb = PlayerBomb x, y
      Driver\addObject bomb, EntityTypes.background
    super x, y, sprite, 7, effect
    @name = "Bomb"
    @description = "A bomb randomly spawns on the screen"
