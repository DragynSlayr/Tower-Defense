export class ShieldActive extends ActiveItem
  new: (x, y) =>
    sprite = Sprite "item/shield.tga", 32, 32, 1, 1.75
    effect = (player) =>
      player.shielded = true
    super x, y, sprite, 20, effect
    @name = "Shield"
    @description = "Gives a temporary shield"
