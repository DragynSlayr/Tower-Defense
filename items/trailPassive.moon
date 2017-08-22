export class TrailPassive extends PassiveItem
  new: (x, y) =>
    @rarity = @getRandomRarity!
    @life_time = ({1.5, 1.75, 2, 2.25, 2.5})[@rarity]
    sprite = Sprite "item/trailPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      sprite = Sprite "item/trailPassive.tga", 32, 32, 1, 1.75
      trail = ParticleTrail player.position.x, player.position.y, sprite, player
      trail.life_time = @life_time
      trail.particle_type = ParticleTypes.enemy_poison
      @old_trail = player.trail
      player.trail = trail
    super x, y, sprite, nil, effect
    @name = "Poison Trail"
    @description = "A trail of poison follows the player"

  getStats: =>
    stats = super!
    table.insert stats, "Length: " .. @life_time
    return stats

  unequip: (player) =>
    super player
    player.trail = @old_trail
