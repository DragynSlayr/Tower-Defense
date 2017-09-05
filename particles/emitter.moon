export class ParticleEmitter extends GameObject
  new: (x, y, delay = 1, life_time = 1, parent = nil) =>
    sprite = Sprite "particle/particle.tga", 32, 32, 1, 0.5
    sprite\setColor {0, 0, 0, 0}
    super x, y, sprite
    @emitting = true
    @delay = delay
    @life_time = life_time
    @id = EntityTypes.particle
    @draw_health = false
    @parent = parent
    @shader = nil
    @particle_type = ParticleTypes.normal
    @moving_particles = true
    @life_time_range = {@life_time, @life_time}
    @size_range = {1, 1}
    @speed_range = {250, 250}
    @velocity = Vector 0, 0

  start: =>
    @emitting = true

  stop: =>
    @emitting = false

  setSizeRange: (range) =>
    @size_range = range

  setLifeTimeRange: (range) =>
    @life_time_range = range

  setSpeedRange: (range) =>
    @speed_range = range

  setVelocity: (velocity) =>
    @velocity = velocity

  update: (dt) =>
    if @parent
      if @parent.alive
        @position = @parent.position
      else
        @kill!
    @elapsed += dt
    if @emitting and @elapsed >= @delay
      @elapsed = 0
      life_time = map math.random!, 0, 1, @life_time_range[1], @life_time_range[2]
      scale = map math.random!, 0, 1, @size_range[1], @size_range[2]
      sprite = @sprite\getCopy!
      sprite\scaleUniformly scale
      particle = switch @particle_type
        when ParticleTypes.normal
          Particle @position.x, @position.y, sprite, 200, 50, life_time
        when ParticleTypes.poison
          PoisonParticle @position.x, @position.y, sprite, 200, 50, life_time
        when ParticleTypes.enemy_poison
          EnemyPoisonParticle @position.x, @position.y, sprite, 255, 0, life_time
      if @moving_particles
        x, y = getRandomUnitStart!
        particle.speed = Vector x, y, true
        speed = map math.random!, 0, 1, @speed_range[1], @speed_range[2]
        particle.speed = particle.speed\multiply speed * Scale.diag
      else
        particle.speed = @velocity
      particle\setShader @shader, true
      Driver\addObject particle, EntityTypes.particle
