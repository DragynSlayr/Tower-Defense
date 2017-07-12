export class HealthBoostPassive extends PassiveItem
  new: (x, y) =>
    sprite = Sprite "item/healthBoost.tga", 24, 24, 1, 56 / 24
    effect = (player) =>
      player.max_health *= 1.2
      player.health = player.max_health
    super x, y, sprite, nil, effect
    @name = "Health Up"
    @description = "Raises player health by 20%"

  unequip: (player) =>
    super player
    player.max_health /= 1.2
    player.health = player.max_health
