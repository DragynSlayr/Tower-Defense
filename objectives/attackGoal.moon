export class AttackGoal extends GameObject
  new: (x, y) =>
    sprite = Sprite "objective/portal.tga", 56, 56, 1, 1.1
    color = {127, 0, 100, 255}
    sprite\setColor color
    sprite\setRotationSpeed math.pi * -0.75
    super x, y, sprite
    @id = EntityTypes.goal
    @goal_type = GoalTypes.attack
    @health = 100 + (33 * Objectives\getLevel!)
    @max_health = @health
    @item_drop_chance = 0.2
