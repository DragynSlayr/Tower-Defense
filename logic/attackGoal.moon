export class AttackGoal extends GameObject
  new: (x, y) =>
    sprite = Sprite "boss/eye/eye.tga", 56, 56, 1, 1.1
    color = {127, 0, 100, 255}
    sprite\setColor color
    sprite\setRotationSpeed math.pi * -0.75
    super x, y, sprite
    @id = EntityTypes.goal
    @goal_type = GoalTypes.attack
