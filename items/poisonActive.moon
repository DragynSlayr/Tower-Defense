export class PoisonFieldActive extends ActiveItem
  new: (x, y) =>
    sprite = Sprite "background/poisonField.tga", 32, 32, 2, 1.75
    effect = (player) =>
      field = PoisonField player.position.x, player.position.y
      Driver\addObject field, EntityTypes.background
    super x, y, sprite, 15, effect
    @name = "Poison Field"
    @description = "Place a poison field"
