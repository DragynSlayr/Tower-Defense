export class MoltenCoreActive extends ActiveItem
  new: (x, y) =>
    sprite = Sprite "item/moltenCoreActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      @used = true
      for k, t in pairs player.turret
        t.buffed = true
        t.damage *= 2
        t.health *= 2
        t.max_health *= 2
    super x, y, sprite, 30, effect
    @name = "Molten Core"
    @description = "Boosts turret damage and health"
    @used = false
    @effect_time = 10
    @effect_timer = 0
    @effect_sprite = Sprite "effect/damageBoost.tga", 32, 32, 0.5, 1

  update2: (dt) =>
    super dt
    if @used
      @effect_sprite\update dt
      @effect_timer += dt
      if @effect_timer >= @effect_time
        @effect_timer = 0
        @used = false
        for k, t in pairs @player.turret
          if t.buffed
            t.buffed = nil
            t.damage /= 2
            t.health /= 2
            t.max_health /= 2

  draw2: =>
    super!
    if @used
      love.graphics.push "all"
      love.graphics.setShader Driver.shader
      for k, t in pairs @player.turret
        if t.buffed
          @effect_sprite\draw t.position.x, t.position.y
      love.graphics.setShader!
      love.graphics.pop!
