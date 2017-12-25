export class HealingFieldActive extends ActiveItem
  new: =>
    @rarity = @getRandomRarity!
    cd = ({15, 14, 13, 12, 11})[@rarity]
    sprite = Sprite "background/healingField.tga", 32, 32, 2, 1.75
    effect = (player) =>
      field = HealingField player.position.x, player.position.y
      Driver\addObject field, EntityTypes.background
    super sprite, cd, effect
    @name = "Healing Field"
    @description = "Place a healing field"
    @effect_time = 6.5
