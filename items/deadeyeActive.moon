export class DeadEyeActive extends ActiveItem
  new: (x, y) =>
    sprite = Sprite "item/deadeyeActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      @used = true
      player.movement_blocked = true
      @damage = 0
    super x, y, sprite, 10, effect
    @name = "Dead Eye"
    @description = "Take aim and fire"
    @used = false
    @effect_time = 6
    @effect_timer = 0
    @damage = 0
    @damage_scale = 1
    @effect_sprite = Sprite "effect/deadeye.tga", 32, 32, 1, 1.75

  fire: =>
    filters = {EntityTypes.enemy, EntityTypes.boss}
    for k2, filter in pairs filters
      if Driver.objects[filter]
        for k, v in pairs Driver.objects[filter]
          print "B: " .. v.health
          v\onCollide @
          print "A: " .. v.health
    @effect_timer = 0
    @damage = 0
    @used = false
    @player.movement_blocked = false

  pickup: (player) =>
    super player
    @damage_scale = player.damage * 10

  use: =>
    if @used
      @fire!
    elseif @charged
      @timer = 0
      @charged = false
      @effect @player
    else
      print "On Cooldown: " .. math.floor (@charge_time - @timer)

  update2: (dt) =>
    if @used
      @effect_sprite\update dt
      @effect_timer += dt
      @damage += @damage_scale * dt
      print "Damage: " .. @damage
      if @effect_timer >= @effect_time
        @fire!
    else
      @timer += dt
      if not @charged and @timer >= @charge_time
        @timer = 0
        @charged = true

  draw2: =>
    super!
    if @used
      love.graphics.push "all"
      love.graphics.setShader Driver.shader
      filters = {EntityTypes.enemy, EntityTypes.boss}
      for k2, filter in pairs filters
        if Driver.objects[filter]
          for k, v in pairs Driver.objects[filter]
            if v.health + v.armor <= @damage
              @effect_sprite\draw v.position.x, v.position.y
      love.graphics.setShader!
      love.graphics.pop!
