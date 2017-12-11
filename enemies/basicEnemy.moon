export class BasicEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/tracker.tga", 32, 32, 1, 1.25
    attack_speed = math.max 0.5, 0.75 - (0.01 * Objectives\getScaling!)
    super x, y, sprite, 1, attack_speed
    @enemyType = EnemyTypes.basic
    @score_value = 100
    @exp_given = @score_value + (@score_value * 0.25 * Objectives\getLevel!)

    @health = math.min 519, 12 + (84.5 * Objectives\getScaling!)
    @max_health = @health
    @max_speed = math.min 500 * Scale.diag, (175 + (54 * Objectives\getScaling!)) * Scale.diag
    @speed_multiplier = @max_speed
    @damage = math.min 37, 1 + (6 * Objectives\getScaling!)

    sound = Sound "basic_enemy_death.ogg", 0.75, false, 1.5, true
    @death_sound = MusicPlayer\add sound

  __tostring: =>
    return "T: " .. @enemyType .. "\tH: " .. @max_health .. "\tD: " .. @damage .. "\tS: " .. @max_speed
