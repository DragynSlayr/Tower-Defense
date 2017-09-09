export class StrongEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/bullet.tga", 26, 20, 1, 2
    attack_speed = math.max 0.5, 0.8 - (0.01 * Objectives\getScaling!)
    super x, y, sprite, 1, attack_speed
    @enemyType = EnemyTypes.strong
    @score_value = 200

    @health = math.min 700, 18 + (113.5 * Objectives\getScaling!)
    @max_health = @health
    @max_speed = math.min 325 * Scale.diag, (100 + (37.5 * Objectives\getScaling!)) * Scale.diag
    @speed_multiplier = @max_speed
    @damage = math.min 61, 1.5 + (10 * Objectives\getScaling!)

    sound = Sound "strong_enemy_death.ogg", 0.25, false, 0.13, true
    @death_sound = MusicPlayer\add sound

  __tostring: =>
    return "T: " .. @enemyType .. "\tH: " .. @max_health .. "\tD: " .. @damage .. "\tS: " .. @max_speed
