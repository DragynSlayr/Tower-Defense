export class DamageBoostActive extends ActiveItem
  new: (x, y) =>
    sprite = Sprite "item/damageBoost.tga", 32, 32, 1, 1.75
    effect = (player) =>
      print "Activated"
      print "B: " .. @player.damage
      @player.damage *= 2
      print "A: " .. @player.damage
      @used = true
    super x, y, sprite, 15, effect
    @name = "Damage Boost"
    @description = "Gives a temporary boost to damage"
    @used = false
    @effect_time = 3
    @effect_timer = 0
    @effect_sprite = Sprite "effect/damageBoost.tga", 32, 32, 0.5, 2.25

  update2: (dt) =>
    super dt
    if @used
      @effect_sprite\update dt
      @effect_timer += dt
      if @effect_timer >= @effect_time
        @effect_timer = 0
        @used = false
        @player.damage = Stats.player[3]
        print "Restored: " .. @player.damage

  draw2: =>
    super!
    if @used
      love.graphics.push "all"
      love.graphics.setShader Driver.shader
      @effect_sprite\draw @player.position.x, @player.position.y
      love.graphics.setShader!
      love.graphics.pop!
