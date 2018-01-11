export class PoisonFieldActive extends ActiveItem
  new: (rarity) =>
    @rarity = rarity
    cd = ({15, 14, 13, 12, 11})[@rarity]
    sprite = Sprite "background/poisonField.tga", 32, 32, 2, 1.75
    effect = (player) =>
      field = PoisonField player.position.x, player.position.y
      Driver\addObject field, EntityTypes.background
    super sprite, cd, effect
    @name = "Toxic Patch"
    @description = "Place a poison field"
    @effect_time = 7.5
