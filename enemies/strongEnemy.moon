export class StrongEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/bullet.tga", 26, 20, 1, 2
    attack_speed = 0.8 - (0.01 * Objectives\getLevel!)
    attack_speed = math.max 0.5, attack_speed
    super x, y, sprite, 1, attack_speed
    @enemyType = EnemyTypes.strong
    @score_value = 200

    @health = 18 + (19.2 * Objectives\getLevel!)
    @max_health = @health
    @max_speed = (100 + (3 * Objectives\getLevel!)) * Scale.diag
    @speed_multiplier = @max_speed
    @damage = 1.5 + (1.5 * Objectives\getLevel!)

  __tostring: =>
    return "T: " .. @enemyType .. "\tH: " .. @max_health .. "\tD: " .. @damage .. "\tS: " .. @max_speed
