export class DeadEyeActive extends ActiveItem
  new: (x, y) =>
    sprite = Sprite "item/deadeyeActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      @used = true
      player.movement_blocked = true
      @damage = 0
    super x, y, sprite, 15, effect
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
          v\onCollide @
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
      if @effect_timer >= @effect_time
        @fire!
      @sprite.shader\send "amount", 1
    else
      @timer += dt
      if not @charged and @timer >= @charge_time
        @timer = 0
        @charged = true
      amount = 0
      if not @charged
        amount = 1 - (@timer / @charge_time)
      @sprite.shader\send "amount", amount

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

      radius = @player\getHitBox!.radius
      x = @player.position.x - radius
      y = @player.position.y + radius + (5 * Scale.height)

      love.graphics.setColor 0, 0, 0, 255
      love.graphics.rectangle "fill", x, y, radius * 2, 10 * Scale.height

      ratio = (@effect_time - @effect_timer) / @effect_time

      love.graphics.setColor 0, 255, 255, 127
      love.graphics.rectangle "fill", x + (1 * Scale.width), y + (1 * Scale.height), ((radius * 2) - (2 * Scale.width)) * ratio, 8 * Scale.height

      love.graphics.setShader!
      love.graphics.pop!
