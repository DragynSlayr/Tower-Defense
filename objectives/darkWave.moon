export class DarkWave extends Wave
  new: (parent) =>
    super parent
    @killed = 0
    @target = @parent.wave_count
    @spawn_count = @target
    @max_time = (1 / @spawn_count) + 1
    @parent.parent.shader = love.graphics.newShader "shaders/distance.fs"
    @parent.parent.shader\send "screen_size", Screen_Size.size
    @parent.parent.shader\send "size", (10 - (0.5 * Upgrade.player_stats[2])) * Scale.diag

  start: =>
    for i = 1, @target
      @parent.parent\spawn GoalTypes.find
    if Driver.objects[EntityTypes.player]
      for k, p in pairs Driver.objects[EntityTypes.player]
        p.attack_range = Base_Stats.player[2]

  entityKilled: (entity) =>
    if entity.id == EntityTypes.goal
      @killed += 1

  update: (dt) =>
    if Driver.objects[EntityTypes.player]
      for k, v in pairs Driver.objects[EntityTypes.player]
        @parent.parent.shader\send "player_pos", {v.position.x, v.position.y}

    super dt
    if not @waiting
      @elapsed += dt
      if @elapsed >= @max_time and @killed ~= @target
        @elapsed = 0
        @spawn_count += 1
        @max_time = (1 / @spawn_count) + 1
        --print "N: " .. @max_time .. "\tS: " .. @spawn_count
        @parent.parent\spawn EnemyTypes.player
    if @killed == @target
      @complete = true
      Driver\killEnemies!

  draw: =>
    num = @target - @killed
    message = "hearts"
    if num == 1
      message = "heart"
    @parent.message1 = "\t" .. num .. " " .. message .. " remaining!"
    super!
