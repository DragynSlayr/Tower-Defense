export class ArmorPassive extends PassiveItem
  new: (x, y) =>
    sprite = Sprite "item/armorPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      player\setArmor player.armor + (player.max_armor * 0.005), player.max_armor
    super x, y, sprite, 0.5, effect
    @name = "Armor Generator"
    @description = "Provides armor over time"
