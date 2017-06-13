export class ParticleTrail extends GameObject
  new: (x, y, sprite, parent) =>
    super x, y, sprite\getCopy!
    @parent = parent
    @last_position = Vector @parent.position\getComponents!
    @position = @last_position

  update: (dt) =>
    if @speed\getLength! > 0
      @position\add @speed\multiply dt
    else
      @position = @parent.position
    change = Vector @last_position.x - @position.x, @last_position.y - @position.y
    if change\getLength! > 20
      @last_position = Vector @parent.position\getComponents!
      particle = Particle @position.x, @position.y, @sprite\getCopy!, 200, 50, 2.5--(Sprite "test.tga", 16, 16, 0.29, 4), nil, nil, 10
      Driver\addObject particle, EntityTypes.particle
