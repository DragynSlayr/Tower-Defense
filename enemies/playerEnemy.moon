export class PlayerEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/enemy.tga", 26, 26, 1, 0.75
    attack_speed = math.max 0.3, 0.6 - (0.01 * Objectives\getScaling!)
    super x, y, sprite, 1, attack_speed
    @enemyType = EnemyTypes.player
    @score_value = 150
    @exp_given = @score_value + (@score_value * 0.30 * Objectives\getLevel!)

    @health = math.min 350, 6 + (32 * Objectives\getScaling!)
    @max_health = @health
    @max_speed = math.min 625 * Scale.diag, (300 + (50 * Objectives\getScaling!)) * Scale.diag
    @speed_multiplier = @max_speed
    @damage = math.min 9.5, 0.5 + (1.5 * Objectives\getScaling!)

    sound = Sound "player_enemy_death.ogg", 2.0, false, 1.25, true
    @death_sound = MusicPlayer\add sound

  __tostring: =>
    return "T: " .. @enemyType .. "\tH: " .. @max_health .. "\tD: " .. @damage .. "\tS: " .. @max_speed

  findNearestTarget: =>
    closest = nil
    closest_distance = math.max love.graphics.getWidth! * 2, love.graphics.getHeight! * 2
    if Driver.objects[EntityTypes.player]
      for k, v in pairs Driver.objects[EntityTypes.player]
        player = v\getHitBox!
        enemy = @getHitBox!
        dist = Vector enemy.center.x - player.center.x, enemy.center.y - player.center.y
        if dist\getLength! < closest_distance
          closest_distance = dist\getLength!
          closest = v
    @target = closest
