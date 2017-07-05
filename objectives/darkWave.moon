export class DarkWave extends Wave
  new: (parent) =>
    super parent
    @killed = 0
    @target = 4 - @parent.wave_count
    @parent.parent.shader = love.graphics.newShader "shaders/distance.fs"
    @parent.parent.shader\send "screen_size", Screen_Size.size
    @parent.parent.shader\send "size", 10 - (0.5 * Upgrade.player_stats[2])
    a = math.log Stats.player[1]
    b = math.log Base_Stats.player[1]
    @max_health = 25 * (a / b)
    @health = @max_health
    if Driver.objects[EntityTypes.player]
      for k, p in pairs Driver.objects[EntityTypes.player]
        @health = map p.health, 0, p.max_health, 0, @max_health

  start: =>
    for i = 1, @target
      goal = @parent.parent\spawn GoalTypes.find
      if false
        delay = love.math.random 2, 4
        life_time = math.random!
        em = ParticleEmitter 0, 0, delay, life_time, goal
        em.shader = love.graphics.newShader "shaders/normal.fs"
        em.sprite = Sprite "particle/orb.tga", 32, 32, 1, 0.5
        Driver\addObject em, EntityTypes.particle
    if Driver.objects[EntityTypes.player]
      for k, p in pairs Driver.objects[EntityTypes.player]
        p.attack_range = Base_Stats.player[2]

  entityKilled: (entity) =>
    if entity.id == EntityTypes.goal
      @killed += 1
      score = SCORE + 500
      export SCORE = score
      @health += 6
      @health = clamp @health, 0, @max_health

  update: (dt) =>
    if Driver.objects[EntityTypes.player]
      for k, v in pairs Driver.objects[EntityTypes.player]
        @parent.parent.shader\send "player_pos", {v.position.x, v.position.y}

    super dt
    if not @waiting
      if Driver.objects[EntityTypes.player]
        for k, v in pairs Driver.objects[EntityTypes.player]
          @health -= (1 * dt)
          v.health = map @health, 0, @max_health, 0, Stats.player[1]
          v.health = clamp v.health, 0, v.max_health

    if @killed >= @target
      Driver\killEnemies!
      @complete = true

  draw: =>
    num = @target - @killed
    message = "hearts"
    if num == 1
      message = "heart"
    @parent.message1 = "\t" .. num .. " " .. message .. " remaining!"
    super!
