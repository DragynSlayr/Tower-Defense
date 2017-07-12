export class SpeedBoostPassive extends PassiveItem
  new: (x, y) =>
    sprite = Sprite "item/speedBoost.tga", 24, 24, 1, 56 / 24
    effect = (player) =>
      player.max_speed *= 1.2
    super x, y, sprite, nil, effect
    @name = "Speed Up"
    @description = "Raises player speed by 20%"

  unequip: (player) =>
    super player
    player.max_speed /= 1.2
