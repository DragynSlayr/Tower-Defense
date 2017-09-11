export class TestWave extends Wave
  new: (parent) =>
    super parent
    @count = 0
    @max_count = 25

  start: =>
    for i = 1, 64
      p = Driver\getRandomPosition!
      x = (0.95 * p.x) + (0.05 * Screen_Size.half_width)
      y = (0.95 * p.y) + (0.05 * Screen_Size.half_height)
      emitter = ParticleEmitter x, y, math.random! / 2
      emitter\setLifeTimeRange {7.5, 17.5}
      emitter\setSizeRange {0.2, 5}
      emitter\setSpeedRange {100, 350}
      Driver\addObject emitter, EntityTypes.particle
    for i = 1, @max_count
      Objectives\spawn (Objectives\getRandomEnemy!), EntityTypes.enemy

  entityKilled: (entity) =>
    if entity.enemyType
      while @count < @max_count
        Objectives\spawn (Objectives\getRandomEnemy!), EntityTypes.enemy
        @count += 1

  update: (dt) =>
    super dt
    filters = {EntityTypes.player, EntityTypes.turret}
    for k2, filter in pairs filters
      if Driver.objects[filter]
        for k, v in pairs Driver.objects[filter]
          v.health += 10 * dt

    sum = 0
    if Driver.objects[EntityTypes.particle]
      for k, v in pairs Driver.objects[EntityTypes.particle]
        sum += #v.objects
    @parent.message1 = "\tParticles: " .. sum

  draw: =>
    @count = 0
    total = 0
    for k, v in pairs Driver.objects
      if k == EntityTypes.enemy
        @count = #v
      total += #v
    @parent.message2 = "Objects: " .. total
    super!
