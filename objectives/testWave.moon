export class TestWave extends Wave
  new: (parent) =>
    super parent

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

  entityKilled: (entity) =>
    return

  update: (dt) =>
    super dt

  draw: =>
    super!
