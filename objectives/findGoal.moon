export class FindGoal extends GameObject
  new: (x, y) =>
    sprite = Sprite "objective/lockedHeart.tga", 26, 26, 1, 2
    super x, y, sprite
    @id = EntityTypes.goal
    @goal_type = GoalTypes.find
    @draw_health = false

    @trail = nil
    @movement_speed = 250
    @velocity = Vector getRandomUnitStart!
    @angle = 2 * math.pi * (1 / 30)

  update: (dt) =>
    super dt

    if @trail
      x = @position.x - @trail.position.x
      y = @position.y - @trail.position.y
      speed = Vector x, y, true
      speed = speed\multiply (dt * @movement_speed)
      @trail.position\add speed
      @trail\setVelocity @velocity\multiply 0.4
      @velocity\rotate @angle
      @trail\update dt

  onCollide: (object) =>
    if object.id == EntityTypes.player
      @health = 0
