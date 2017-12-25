export class MoltenCoreActive extends ActiveItem
  new: =>
    @rarity = @getRandomRarity!
    cd = ({30, 27, 24, 21, 18})[@rarity]
    sprite = Sprite "item/moltenCoreActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      for k, t in pairs player.turret
        t.buffed = true
        t.damage *= 2
        t.health *= 2
        t.max_health *= 2
    super sprite, cd, effect
    @name = "Molten Core"
    @description = "Boosts turret damage and health"
    @effect_time = ({10, 11, 12, 13, 14})[@rarity]
    @effect_sprite = Sprite "effect/damageBoost.tga", 32, 32, 0.5, 1
    @onEnd = () ->
      for k, t in pairs @player.turret
        if t.buffed
          t.buffed = nil
          t.damage /= 2
          t.health /= 2
          t.max_health /= 2

  getStats: =>
    stats = super!
    table.insert stats, "Duration: " .. @effect_time .. "s"
    return stats

  update2: (dt) =>
    super dt
    if @used
      @effect_sprite\update dt

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
