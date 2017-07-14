export class HealingField extends BackgroundObject
  new: (x, y) =>
    sprite = Sprite "background/healingField.tga", 32, 32, 2, 4
    super x, y, sprite
    @life_time = 6.5
    @timer = 0
    @heal_delay = 0.5
    @healing_amount = 1 / 4

  update: (dt) =>
    super dt
    @timer += dt
    if @timer >= @heal_delay
      @timer = 0
      if Driver.objects[EntityTypes.player]
        for k, p in pairs Driver.objects[EntityTypes.player]
          target = p\getHitBox!
          healer = @getHitBox!
          if target\contains healer
            p.health = clamp p.health + @healing_amount, 0, p.max_health
      if Driver.objects[EntityTypes.turret]
        for k, t in pairs Driver.objects[EntityTypes.turret]
          target = t\getAttackHitBox!
          healer = @getHitBox!
          if target\contains healer
            t.health = clamp t.health + @healing_amount, 0, t.max_health
    @life_time -= dt
    if @life_time <= 0
      @health = 0
