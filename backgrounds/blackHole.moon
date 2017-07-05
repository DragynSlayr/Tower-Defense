export class BlackHole extends BackgroundObject
  new: (x, y) =>
    sprite = Sprite "background/blackhole.tga", 32, 32, 1, 1
    super x, y, sprite
    @life_time = 17
    @diag = (Vector Screen_Size.border[3], Screen_Size.border[4])\getLength!

  update: (dt) =>
    super dt
    if Driver.objects[EntityTypes.enemy]
      for k, e in pairs Driver.objects[EntityTypes.enemy]
        @applyPull e, dt
        @applyDamage e
    if Driver.objects[EntityTypes.boss]
      for k, b in pairs Driver.objects[EntityTypes.boss]
        @applyPull b, dt
        @applyDamage b
    @life_time -= dt
    if @life_time <= 0
      @kill!

  applyPull: (entity, dt) =>
    x = @position.x - entity.position.x
    y = @position.y - entity.position.y
    veb = Vector x, y
    ratio = map veb\getLength!, 0, @diag, 0, 10 * Scale.diag
    factor = 1 - (dt / ratio)
    factor /= 50 * Scale.diag
    veb = veb\multiply factor
    entity.position\add veb

  applyDamage: (entity) =>
    x = @position.x - entity.position.x
    y = @position.y - entity.position.y
    veb = Vector x, y
    damage = 0
    num = 0
    if Driver.objects[EntityTypes.player]
      for k, p in pairs Driver.objects[EntityTypes.player]
        damage += p.damage
        num += 1
    damage /= num
    @damage = map veb\getLength!, 0, @diag, 0, damage / 2
    entity\onCollide @
