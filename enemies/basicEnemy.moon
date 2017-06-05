export class BasicEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/tracker.tga", 32, 32, 1, 1.25
    attack_speed = 0.75 - (0.01 * Objectives\getLevel!)
    attack_speed = math.max 0.5, attack_speed
    super x, y, sprite, 1, attack_speed
    @enemyType = EnemyTypes.basic
    @score_value = 100

    @health = 12 + (12.8 * Objectives\getLevel!)
    @max_health = @health
    @max_speed = (175 + (10.8 * Objectives\getLevel!)) * Scale.diag
    @speed_multiplier = @max_speed
    @damage = 1 + (0.55 * Objectives\getLevel!)

  __tostring: =>
    return "T: " .. @enemyType .. "\tH: " .. @max_health .. "\tD: " .. @damage .. "\tS: " .. @max_speed
