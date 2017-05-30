export class FindGoal extends GameObject
  new: (x, y) =>
    sprite = Sprite "player/sentry.tga", 26, 26, 1, 2
    super x, y, sprite
    @id = EntityTypes.goal
    @goal_type = GoalTypes.find
    @draw_health = false

  onCollide: (object) =>
    if object.id == EntityTypes.player
      @health = 0
