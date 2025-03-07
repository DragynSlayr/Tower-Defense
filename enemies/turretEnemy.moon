export class TurretEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/circle.tga", 26, 26, 1, 1.75
    attack_speed = math.max 0.5, 0.75 - (0.01 * Objectives\getScaling!)
    super x, y, sprite, 1, attack_speed
    @enemyType = EnemyTypes.turret
    @score_value = 150
    @exp_given = @score_value + (@score_value * 0.35 * Objectives\getLevel!)

    @health = 15 + (36 * Objectives\getScaling!)
    @max_health = @health
    @max_speed = 200 * Scale.diag--math.min 360 * Scale.diag, (200 + (26.5 * Objectives\getScaling!)) * Scale.diag
    @speed_multiplier = @max_speed
    @damage = 2--math.min 46, 2 + (7.35 * Objectives\getScaling!)

    sound = Sound "turret_enemy_death.ogg", 0.75, false, 0.75, true
    @death_sound = MusicPlayer\add sound

    @attack_filters = {}

  __tostring: =>
    return "T: " .. @enemyType .. "\tH: " .. @max_health .. "\tD: " .. @damage .. "\tS: " .. @max_speed

  update: (dt) =>
    if not @alive return
    if #Driver.objects[EntityTypes.turret] ~= 0
      super dt, false
    else
      super dt, true
    @sprite.rotation -= math.pi / 4

  findNearestTarget: (all = false) =>
    closest = nil
    closest_distance = math.max Screen_Size.width * 2, Screen_Size.height * 2
    if all
      for k, v in pairs Driver.objects[EntityTypes.player]
        player = v\getHitBox!
        enemy = @getHitBox!
        dist = Vector enemy.center.x - player.center.x, enemy.center.y - player.center.y
        if dist\getLength! < closest_distance
          closest_distance = dist\getLength!
          closest = v
    for k, v in pairs Driver.objects[EntityTypes.turret]
      turret = v\getAttackHitBox!
      enemy = @getHitBox!
      dist = Vector enemy.center.x - turret.center.x, enemy.center.y - turret.center.y
      if dist\getLength! < closest_distance
        closest_distance = dist\getLength!
        closest = v
    @target = closest
