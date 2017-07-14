export class FreezeFieldActive extends ActiveItem
  new: (x, y) =>
    sprite = Sprite "background/frostField.tga", 32, 32, 2, 1.75
    effect = (player) =>
      field = FrostField player.position.x, player.position.y
      Driver\addObject field, EntityTypes.background
    super x, y, sprite, 15, effect
    @name = "Frozen Field"
    @description = "Place a frozen field"
