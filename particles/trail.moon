export class ParticleTrail extends GameObject
  new: (x, y, sprite, parent) =>
    super x, y, sprite\getCopy!
    @parent = parent
    @last_position = Vector @parent.position\getComponents!
    @position = @last_position
    @life_time = 1
    @average_size = (@sprite.scaled_width + @sprite.scaled_height) / 8
    @particle_type = ParticleTypes.normal

  update: (dt) =>
    if @speed\getLength! > 0
      @position\add @speed\multiply dt
    else
      @position = @parent.position
    @sprite.rotation = @parent.sprite.rotation
    change = Vector @last_position.x - @position.x, @last_position.y - @position.y
    if change\getLength! >= @average_size
      @last_position = Vector @parent.position\getComponents!
      particle = switch @particle_type
        when ParticleTypes.normal
          Particle @position.x, @position.y, @sprite, 255, 0, @life_time
        when ParticleTypes.poison
          PoisonParticle @position.x, @position.y, @sprite, 255, 0, @life_time
        when ParticleTypes.enemy_poison
          EnemyPoisonParticle @position.x, @position.y, @sprite, 255, 0, @life_time
      Driver\addObject particle, EntityTypes.particle
