export class DefendGoal extends GameObject
  new: (x, y) =>
    sprite = Sprite "player/sentry.tga", 26, 26, 1, 2
    color = {0, 127, 100, 255}
    --sprite\setColor color
    super x, y, sprite
    @id = EntityTypes.goal
    @goal_type = GoalTypes.defend
    @health = 10 + (Scaling.health * Objectives\getLevel!)
    @max_health = @health
    --print "DG: " .. @max_health
