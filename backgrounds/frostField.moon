export class FrostField extends BackgroundObject
  new: (x, y) =>
    sprite = Sprite "background/frostField.tga", 32, 32, 2, 8
    sprite.color[4] = 200
    super x, y, sprite
    @life_time = 7.5
    @timer = 0
    @frost_delay = 0.1

  update: (dt) =>
    super dt
    @timer += dt
    if @timer >= @frost_delay
      @timer = 0
      if Driver.objects[EntityTypes.enemy]
        for k, e in pairs Driver.objects[EntityTypes.enemy]
          target = e\getHitBox!
          frost = @getHitBox!
          if target\contains frost
            e.speed_multiplier *= 0.5
      if Driver.objects[EntityTypes.boss]
        for k, b in pairs Driver.objects[EntityTypes.boss]
          target = b\getHitBox!
          frost = @getHitBox!
          if target\contains frost
            b.speed_multiplier *= 0.5
    @life_time -= dt
    if @life_time <= 0
      @health = 0
