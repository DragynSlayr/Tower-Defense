export class BasicEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/tracker.tga", 25, 25, 1, 2
    super x, y, sprite
    @enemyType = EnemyTypes.basic
    @score_value = 100

    @health = 5 + (2.5 * Objectives\getLevel!)
    @max_health = @health
    @max_speed = 150 + (5 * Objectives\getLevel!)
    @speed_multiplier = @max_speed
    @damage = 1 + (1 * Objectives\getLevel!)

  __tostring: =>
    return "T: " .. @enemyType .. "\tH: " .. @max_health .. "\tD: " .. @damage .. "\tS: " .. @max_speed
