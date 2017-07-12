export class DamageBoostPassive extends PassiveItem
  new: (x, y) =>
    sprite = Sprite "item/damageBoostPassive.tga", 24, 24, 1, 56 / 24
    effect = (player) =>
      player.damage *= 1.2
    super x, y, sprite, nil, effect
    @name = "Damage Up"
    @description = "Raises player damage by 20%"

  unequip: (player) =>
    super player
    player.damage /= 1.2
