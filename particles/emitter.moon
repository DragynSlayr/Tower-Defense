export class ParticleEmitter extends GameObject
  new: (x, y, delay, life_time, parent) =>
    sprite = Sprite "block.tga", 32, 32, 1, 1
    sprite\setColor {0, 0, 0, 0}
    super x, y, sprite
    @emitting = true
    @delay = delay
    @life_time = life_time
    @id = EntityTypes.particle
    @draw_health = false
    @parent = parent

  start: =>
    @emitting = true

  stop: =>
    @emitting = false

  update: (dt) =>
    if @parent
      if @parent.alive
        @position = @parent.position
      else
        @kill!
    @elapsed += dt
    if @elapsed >= @delay
      @elapsed = 0
      particle = Particle @position.x, @position.y, (Sprite "particle.tga", 32, 32, 1, 0.5), 200, 50, @life_time
      x, y = getRandomUnitStart!
      particle.speed = Vector x, y, true
      particle.speed = particle.speed\multiply 250 * Scale.diag
      Driver\addObject particle, EntityTypes.particle
