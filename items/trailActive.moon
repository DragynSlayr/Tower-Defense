export class TrailActive extends ActiveItem
  new: (x, y) =>
    @rarity = @getRandomRarity!
    cd = ({30, 25, 20, 15, 10})[@rarity]
    sprite = Sprite "item/trailActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      sprite = Sprite "item/trailActive.tga", 32, 32, 1, 1.75
      trail = ParticleTrail player.position.x, player.position.y, sprite, player
      trail.life_time = @effect_time
      trail.particle_type = ParticleTypes.enemy_poison
      @old_trail = player.trail
      player.trail = trail
    super x, y, sprite, cd, effect
    @name = "Fire Trail"
    @description = "A trail of fire follows the player"
    @effect_time = ({7.5, 7.75, 8, 8.25, 8.5})[@rarity]
    @effect_timer = 0
    @onEnd = () -> @player.trail = @old_trail

  getStats: =>
    stats = super!
    table.insert stats, "Trail Time: " .. @effect_time .. "s"
    return stats
