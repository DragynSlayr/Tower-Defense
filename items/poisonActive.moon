export class PoisonFieldActive extends ActiveItem
  new: (x, y) =>
    @rarity = @getRandomRarity!
    cd = ({15, 14, 13, 12, 11})[@rarity]
    sprite = Sprite "background/poisonField.tga", 32, 32, 2, 1.75
    effect = (player) =>
      field = PoisonField player.position.x, player.position.y
      Driver\addObject field, EntityTypes.background
    super x, y, sprite, cd, effect
    @name = "Poison Field"
    @description = "Place a poison field"
    @effect_time = 7.5
