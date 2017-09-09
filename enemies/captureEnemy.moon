export class CaptureEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/capture.tga", 32, 32, 1, 25 / 32
    super x, y, sprite, 0, 0
    @enemyType = EnemyTypes.capture
    @score_value = 100
    --@solid = false
    @corner_target = false

    @health = math.min 346, 5 + (57 * Objectives\getScaling!)
    @max_health = @health
    @max_speed = math.min 650 * Scale.diag, (300 + (58.5 * Objectives\getScaling!)) * Scale.diag
    @speed_multiplier = @max_speed
    @damage = 10 / 3

    sound = Sound "capture_enemy_death.ogg", 0.75, false, 1.25, true
    @death_sound = MusicPlayer\add sound

  __tostring: =>
    return "T: " .. @enemyType .. "\tH: " .. @max_health .. "\tD: " .. @damage .. "\tS: " .. @max_speed

  findNearestTarget: =>
    if not @target or not @target.alive
      if Driver.objects[EntityTypes.goal]
        @target = pick Driver.objects[EntityTypes.goal]
        while @target.goal_type == GoalTypes.tesseract
          @target = pick Driver.objects[EntityTypes.goal]
