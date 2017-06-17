export class CaptureEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "boss/orb/orb.tga", 32, 32, 1, 25 / 32
    super x, y, sprite, 0, 0
    @enemyType = EnemyTypes.capture
    @score_value = 100
    @solid = false
    @corner_target = false

    @health = 12 + (12.8 * Objectives\getLevel!)
    @max_health = @health
    @max_speed = (250 + (10.8 * Objectives\getLevel!)) * Scale.diag
    @speed_multiplier = @max_speed
    @damage = 1 + (0.55 * Objectives\getLevel!)

  __tostring: =>
    return "T: " .. @enemyType .. "\tH: " .. @max_health .. "\tD: " .. @damage .. "\tS: " .. @max_speed

  findNearestTarget: =>
    if not @target or not @target.alive
      if Driver.objects[EntityTypes.goal]
        @target = pick Driver.objects[EntityTypes.goal]
