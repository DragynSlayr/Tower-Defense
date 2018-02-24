export class TurretFollowerPassive extends PassiveItem
  new: (rarity) =>
    @rarity = rarity
    sprite = Sprite "item/turretFollowerPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      if not @turret_placed
        @turret_placed = true
        turret = FollowerTurret player.position.x, player.position.y, player
        turret.damage *= @damage_multiplier
        turret.attack_speed *= @attack_speed
        Driver\addObject turret, EntityTypes.background
    super sprite, 0, effect
    @name = "Follower"
    @description = "A turret follows the player"
    @turret_placed = false
    @damage_multiplier = ({0.25, 0.35, 0.45, 0.55, 0.65})[@rarity]
    @attack_speed = ({3, 2.7, 2.4, 2.1, 1.8, 1.5})[@rarity]

  pickup: (player) =>
    @turret_placed = false
    super player

  getStats: =>
    stats = super!
    table.insert stats, "Damage Multiplier: " .. @damage_multiplier
    table.insert stats, "Fire Delay Multiplier: " .. @attack_speed
    return stats
