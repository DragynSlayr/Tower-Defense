export class TesseractGoal extends GameObject
  new: (x, y) =>
    sprite = Sprite "objective/tesseract.tga", 32, 32, 1, 56 / 32
    --color = {127, 0, 100, 255}
    --sprite\setColor color
    --sprite\setRotationSpeed math.pi * -0.75
    super x, y, sprite
    @id = EntityTypes.goal
    @goal_type = GoalTypes.tesseract
    @health = 100 + (33 * Objectives\getLevel!)
    @max_health = @health
    @reduction = 0

  onCollide: (entity) =>
    start_damage = entity.damage
    entity.damage *= @reduction
    super entity
    entity.damage = start_damage

  update: (dt) =>
    super dt
    health = 0
    max_health = 0
    if Driver.objects[EntityTypes.goal]
      for k, g in pairs Driver.objects[EntityTypes.goal]
        if g.capture_amount
          health += g.capture_amount
          max_health += g.max_health
    @reduction = health / max_health
