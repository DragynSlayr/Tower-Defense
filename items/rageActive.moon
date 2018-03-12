export class RageActive extends ActiveItem
  @lowest_rarity = 1
  @highest_rarity = 5
  @probability = 1000
  new: (rarity) =>
    @rarity = rarity
    -- TODO: Change this sprite
    sprite = Sprite "background/clone.tga", 32, 32, 1, 1.75
    effect = (player) =>
      player.old = {}
      player.old[1] = player.max_shield_time
      player.old[2] = player.damage
      player.old[3] = player.shield_sprite
      player.shield_sprite = Sprite "effect/rageShield.tga", 32, 32, 1, 3
      player.shield_sprite\setRotationSpeed (math.pi / 2)
      player.shielded = true
      player.shield_timer = 0
      player.max_shield_time = @start_effect_time
    super sprite, 10, effect
    @name = "Test"
    @description = "Gio's Item"
    @start_effect_time = 10
    @effect_time = @start_effect_time
    @start_effect_delta = 3
    @effect_delta = @start_effect_delta
    @start_target_delta = 3
    @target_delta = @start_target_delta
    @start_target_count = 3
    @target_count = @start_target_count
    @kill_count = 0
    @onEnd = () =>
      @player.shielded = false
      @player.shield_timer = 0
      @player.max_shield_time = @player.old[1]
      @player.damage = @player.old[2]
      @player.shield_sprite = @player.old[3]
      @player.old = nil
      @effect_time = @start_effect_time
      @effect_delta = @start_effect_delta
      @target_delta = @start_target_delta
      @target_count = @start_target_count
      @kill_count = 0

  onKill: (entity) =>
    if entity.id == EntityTypes.enemy and entity.__class != CaptureEnemy
      @kill_count += 1
      if @kill_count >= @target_count
        @target_count += @target_delta
        @target_delta += 1

        @player.damage += @effect_delta / 4
        @player.shield_timer = clamp @player.shield_timer - @effect_delta, 0, @player.shield_timer
        @player.max_shield_time += @effect_delta
        @effect_timer = clamp @effect_timer - @effect_delta, 0, @effect_timer
        @effect_time += @effect_delta
        @effect_delta *= 0.95

      print @kill_count .. " / " .. @target_count

  update2: (dt) =>
    if @used
      @charge_time = @effect_time + @timer
      r = @kill_count / @target_count
      @player.shield_sprite\setColor {r * 255, 0, 0, 255}
    super dt
