export class TrailPassive extends PassiveItem
  new: (x, y) =>
    sprite = Sprite "item/trailPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      sprite = Sprite "item/trailPassive.tga", 32, 32, 1, 1.75
      trail = ParticleTrail player.position.x, player.position.y, sprite, player
      trail.life_time = 1.5
      trail.particle_type = ParticleTypes.enemy_poison
      @old_trail = player.trail
      player.trail = trail
    super x, y, sprite, nil, effect
    @name = "Poison Trail"
    @description = "A trail of poison follows the player"

  unequip: (player) =>
    super player
    player.trail = @old_trail
