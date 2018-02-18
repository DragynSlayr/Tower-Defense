export class PoisonField extends BackgroundObject
  new: (x, y) =>
    sprite = Sprite "background/poisonField.tga", 32, 32, 2, 8
    sprite.color[4] = 200
    super x, y, sprite
    @life_time = 7.5
    @timer = 0
    @poison_delay = 0.1
    @poison_amount = 0.5

  update: (dt) =>
    super dt
    @timer += dt
    if @timer >= @poison_delay
      @timer = 0
      for k, e in pairs Driver.objects[EntityTypes.enemy]
        target = e\getHitBox!
        poison = @getHitBox!
        if target\contains poison
          e.health = clamp e.health - @poison_amount, 0, e.max_health
      for k, b in pairs Driver.objects[EntityTypes.boss]
        target = b\getHitBox!
        poison = @getHitBox!
        if target\contains poison
          b.health = clamp b.health - @poison_amount, 0, b.max_health
    @life_time -= dt
    if @life_time <= 0
      @health = 0
