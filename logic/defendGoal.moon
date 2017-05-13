export class DefendGoal extends GameObject
  new: (x, y) =>
    sprite = Sprite "player/sentry.tga", 26, 26, 1, 2
    super x, y, sprite
    @id = EntityTypes.goal
    @goal_type = GoalTypes.defend
