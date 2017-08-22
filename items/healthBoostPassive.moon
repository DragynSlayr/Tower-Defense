export class HealthBoostPassive extends PassiveItem
  new: (x, y) =>
    @rarity = @getRandomRarity!
    @amount = ({1.2, 1.25, 1.3, 1.35, 1.4})[@rarity]
    sprite = Sprite "item/healthBoost.tga", 24, 24, 1, 56 / 24
    effect = (player) =>
      player.max_health *= @amount
      player.health = player.max_health
    super x, y, sprite, nil, effect
    @name = "Health Up"
    @description = "Raises player health by " .. ((@amount - 1) * 100) .. "%"

  unequip: (player) =>
    super player
    player.max_health /= @amount
    player.health = player.max_health
