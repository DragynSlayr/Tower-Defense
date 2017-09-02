export class ShieldActive extends ActiveItem
  new: (x, y) =>
    @rarity = @getRandomRarity!
    cd = ({20, 18, 16, 14, 12})[@rarity]
    sprite = Sprite "item/shield.tga", 32, 32, 1, 1.75
    effect = (player) =>
      player.shielded = true
    super x, y, sprite, cd, effect
    @name = "Shield"
    @description = "Gives a temporary shield"
    @effect_time = 7
