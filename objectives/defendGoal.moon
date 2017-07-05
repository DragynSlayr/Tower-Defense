export class DefendGoal extends GameObject
  new: (x, y) =>
    sprite = Sprite "objective/defend.tga", 26, 27, 1, 2
    color = {0, 127, 100, 255}
    --sprite\setColor color
    super x, y, sprite
    @id = EntityTypes.goal
    @goal_type = GoalTypes.defend
    @health = 10 + (5.5 * Objectives\getLevel!)
    @max_health = @health
