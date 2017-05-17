export class StrongEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/bullet.tga", 26, 20, 1, 2
    super x, y, sprite
    @enemyType = EnemyTypes.strong
    @score_value = 200

    @health = 8 + (4 * Objectives\getLevel!)
    @max_health = @health
    @max_speed = 100 + (3 * Objectives\getLevel!)
    @speed_multiplier = @max_speed
    @damage = 3 + (2.5 * Objectives\getLevel!)

  __tostring: =>
    return "T: " .. @enemyType .. "\tH: " .. @max_health .. "\tD: " .. @damage .. "\tS: " .. @max_speed
