export class TestWave extends Wave
  new: (parent) =>
    super parent
    @emitter = nil

  start: =>
    @emitter = ParticleEmitter Screen_Size.width * 0.75, Screen_Size.height * 0.5, 0
    @emitter\setLifeTimeRange {0.1, 0.4}
    @emitter\setSizeRange {0.1, 1.0}

  entityKilled: (entity) =>
    return

  update: (dt) =>
    super dt
    if not @waiting
      @emitter\update dt

  draw: =>
    if @emitter
      @emitter\draw!
    super!
