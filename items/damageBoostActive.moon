export class DamageBoostActive extends ActiveItem
  new: (x, y) =>
    @rarity = @getRandomRarity!
    cd = ({15, 14, 13, 12, 11})[@rarity]
    sprite = Sprite "item/damageBoost.tga", 32, 32, 1, 1.75
    effect = (player) =>
      @player.damage *= 2
      @used = true
    super x, y, sprite, cd, effect
    @name = "Damage Boost"
    @description = "Gives a temporary boost to damage"
    @used = false
    @effect_time = ({3, 4, 5, 6, 7})[@rarity]
    @effect_timer = 0
    @effect_sprite = Sprite "effect/damageBoost.tga", 32, 32, 0.5, 2.25

  getStats: =>
    stats = super!
    table.insert stats, "Duration: " .. @effect_time .. "s"
    return stats
    
  update2: (dt) =>
    super dt
    if @used
      @effect_sprite\update dt
      @effect_timer += dt
      if @effect_timer >= @effect_time
        @effect_timer = 0
        @used = false
        @player.damage = Stats.player[3]

  draw2: =>
    super!
    if @used
      love.graphics.push "all"
      love.graphics.setShader Driver.shader
      @effect_sprite\draw @player.position.x, @player.position.y
      love.graphics.setShader!
      love.graphics.pop!
