export class ArmorPassive extends PassiveItem
  new: =>
    @rarity = @getRandomRarity!
    cd = ({0.5, 0.4, 0.3, 0.2, 0.1})[@rarity]
    sprite = Sprite "item/armorPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      player\setArmor player.armor + (player.max_armor * 0.005), player.max_armor
    super sprite, cd, effect
    @name = "ArMORE"
    @description = "Provides armor over time"
