export class ExtraLifePassive extends PassiveItem
  new: (x, y) =>
    sprite = Sprite "item/extraLife.tga", 26, 26, 1, 56 / 26
    effect = (player) =>
      player.lives += 1
    super x, y, sprite, nil, effect
    @name = "Heart"
    @description = "Gives an extra life"

  unequip: (player) =>
    player.lives = 1
    super player
