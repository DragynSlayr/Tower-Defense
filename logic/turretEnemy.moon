export class TurretEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/circle.tga", 26, 26, 1, 2
    super x, y, sprite

  update: (dt) =>
    if not @alive return
    if Driver.objects[EntityTypes.turret]
      if #Driver.objects[EntityTypes.turret] ~= 0
        super dt, false
      else
        super dt, true
    else
      super dt, true

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
