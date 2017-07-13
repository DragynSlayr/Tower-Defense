export class TrailActive extends ActiveItem
  new: (x, y) =>
    sprite = Sprite "item/trailActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      sprite = Sprite "item/trailActive.tga", 32, 32, 1, 1.75
      trail = ParticleTrail player.position.x, player.position.y, sprite, player
      trail.life_time = 7.5
      trail.particle_type = ParticleTypes.enemy_poison
      @old_trail = player.trail
      player.trail = trail
      @used = true
    super x, y, sprite, 30, effect
    @name = "Fire Trail"
    @description = "A trail of fire follows the player"
    @used = false
    @effect_time = 7.5
    @effect_timer = 0

  update2: (dt) =>
    super dt
    if @used
      @effect_timer += dt
      if @effect_timer >= @effect_time
        @effect_timer = 0
        @used = false
        @player.trail = @old_trail
