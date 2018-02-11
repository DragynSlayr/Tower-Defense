export class ExtraTurretPassive extends PassiveItem
  @lowest_rarity = 5
  new: (rarity) =>
    @rarity = rarity
    -- TODO: This sprite needs work
    sprite = Sprite "item/extraTurretPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      player.max_turrets += 1
      player.turret_count = player.max_turrets
    super sprite, nil, effect
    @name = "Extra Turret"
    @description = "Up to 2 turrets can be placed"
    effect = (player) =>

  unequip: (player) =>
    super player
    player.max_turrets -= 1
    player.turret_count = player.max_turrets
