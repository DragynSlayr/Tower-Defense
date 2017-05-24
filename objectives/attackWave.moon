export class AttackWave extends Wave
  new: (parent) =>
    super parent
    @killed = 0
    @target = @parent.wave_count
    @spawn_count = @target
    @max_time = (3 / @spawn_count) + 1

  spawnRandomEnemy: =>
    spawnerChance = @parent.parent.spawnerChance / 4
    basicChance = @parent.parent.basicChance + spawnerChance
    playerChance = @parent.parent.playerChance + spawnerChance
    turretChance = @parent.parent.turretChance + spawnerChance
    strongChance = @parent.parent.strongChance + spawnerChance
    @parent.parent\spawn @parent.parent\getRandomEnemy basicChance, playerChance, turretChance, strongChance, 0

  start: =>
    for i = 1, @target
      @parent.parent\spawn GoalTypes.attack

  entityKilled: (entity) =>
    if entity.id == EntityTypes.goal
      @killed += 1
      @spawnRandomEnemy!

  update: (dt) =>
    super dt
    if not @waiting
      @elapsed += dt
      if @elapsed >= @max_time and @killed ~= @target
        @elapsed = 0
        @spawn_count += 1
        @max_time = (3 / @spawn_count) + 1
        --print "N: " .. @max_time .. "\tS: " .. @spawn_count
        @spawnRandomEnemy!
    if @killed == @target and Driver\isClear!
      @complete = true

  draw: =>
    num = @target - @killed
    message = "beacons"
    if num == 1
      message = "beacon"
    @parent.message1 = "\t" .. num .. " " .. message .. " remaining!"
    super!
