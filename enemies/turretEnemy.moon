export class TurretEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/circle.tga", 26, 26, 1, 1.75
    super x, y, sprite, 1, 1
    @enemyType = EnemyTypes.turret
    @score_value = 150

    @health = 15 + (16 * Objectives\getLevel!)
    @max_health = @health
    @max_speed = (200 + (5 * Objectives\getLevel!)) * Scale.diag
    @speed_multiplier = @max_speed
    @damage = 2 + (0.8 * Objectives\getLevel!)

  __tostring: =>
    return "T: " .. @enemyType .. "\tH: " .. @max_health .. "\tD: " .. @damage .. "\tS: " .. @max_speed

  update: (dt) =>
    if not @alive return
    if Driver.objects[EntityTypes.turret]
      if #Driver.objects[EntityTypes.turret] ~= 0
        super dt, false
      else
        super dt, true
    else
      super dt, true
    @sprite.rotation -= math.pi / 4

  findNearestTarget: (all = false) =>
    closest = nil
    closest_distance = math.max love.graphics.getWidth! * 2, love.graphics.getHeight! * 2
    if all
      if Driver.objects[EntityTypes.player]
        for k, v in pairs Driver.objects[EntityTypes.player]
          player = v\getHitBox!
          enemy = @getHitBox!
          dist = Vector enemy.center.x - player.center.x, enemy.center.y - player.center.y
          if dist\getLength! < closest_distance
            closest_distance = dist\getLength!
            closest = v
    if Driver.objects[EntityTypes.turret]
      for k, v in pairs Driver.objects[EntityTypes.turret]
        turret = v\getHitBox!
        enemy = @getHitBox!
        dist = Vector enemy.center.x - turret.center.x, enemy.center.y - turret.center.y
        if dist\getLength! < closest_distance
          closest_distance = dist\getLength!
          closest = v
    @target = closest
