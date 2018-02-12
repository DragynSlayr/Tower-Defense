export class LifeStealPassive extends PassiveItem
  @lowest_rarity = 5
  new: (rarity) =>
    @rarity = rarity
    sprite = Sprite "item/lifeSteal.tga", 32, 32, 1, 1.75
    effect = (player) => return
    super sprite, nil, effect
    @name = "Life Steal"
    @description = "Recover life from hit enemies"
