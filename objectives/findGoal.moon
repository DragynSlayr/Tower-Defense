export class FindGoal extends GameObject
  new: (x, y) =>
    sprite = Sprite "player/sentry.tga", 26, 26, 1, 2
    super x, y, sprite
    @id = EntityTypes.goal
    @goal_type = GoalTypes.find
    @draw_health = false
    @max_time = ((-4 / 30) * Objectives\getLevel!) + 5--5
    @max_time = clamp @max_time, 1, 5

  update: (dt) =>
    super dt
    if @elapsed >= @max_time
      @elapsed = 0
      goal = Objectives\spawn GoalTypes.find
      Driver\removeObject goal, false
      @position = goal.position

  onCollide: (object) =>
    if object.id == EntityTypes.player
      @health = 0
