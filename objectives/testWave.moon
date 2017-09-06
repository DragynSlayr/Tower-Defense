export class TestWave extends Wave
  new: (parent) =>
    super parent
    @system = nil

  start: =>
    for i = 1, 1
      emitter = ParticleEmitter Screen_Size.width * 0.25, Screen_Size.height * 0.5, 0.2
      emitter\setLifeTimeRange {2, 5}
      emitter\setSizeRange {1, 1}
      emitter\setSpeedRange {-20, 20}
      Driver\addObject emitter, EntityTypes.particle

    image = love.graphics.newImage "assets/sprites/particle/particle.tga"
    @system = love.graphics.newParticleSystem image, 50
    @system\setParticleLifetime 2, 5
    @system\setEmissionRate 5
    @system\setLinearAcceleration -20, -20, 20, 20
    @system\setColors 255, 255, 255, 255, 255, 255, 255, 0

  entityKilled: (entity) =>
    return

  update: (dt) =>
    super dt
    if not @waiting
      @system\update dt

  draw: =>
    if @system
      love.graphics.draw @system, Screen_Size.width * 0.75, Screen_Size.height * 0.5
    super!
