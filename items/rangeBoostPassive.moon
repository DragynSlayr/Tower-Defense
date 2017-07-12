export class RangeBoostPassive extends PassiveItem
  new: (x, y) =>
    sprite = Sprite "item/rangeBoost.tga", 24, 24, 1, 56 / 24
    effect = (player) =>
      player.attack_range *= 1.2
    super x, y, sprite, nil, effect
    @name = "Range Up"
    @description = "Raises player range by 20%"

  unequip: (player) =>
    super player
    player.attack_range /= 1.2
