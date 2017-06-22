export class DefendWave extends Wave
  new: (parent) =>
    super parent
    @target = 20
    @dead = 0
    @max_time = 2

  spawnRandomEnemy: =>
    spawnerChance = @parent.parent.spawnerChance / 4
    basicChance = @parent.parent.basicChance + spawnerChance
    playerChance = @parent.parent.playerChance + spawnerChance
    turretChance = @parent.parent.turretChance + spawnerChance
    strongChance = @parent.parent.strongChance + spawnerChance
    @parent.parent\spawn @parent.parent\getRandomEnemy basicChance, playerChance, turretChance, strongChance, 0

  start: =>
    @parent.parent\spawn GoalTypes.defend

  entityKilled: (entity) =>
    if entity.id == EntityTypes.goal
      @dead += 1

  update: (dt) =>
    super dt
    if not @waiting
      @elapsed += dt
      @target -= dt
      if @elapsed >= @max_time and @target > 0
        @elapsed = 0
        @spawnRandomEnemy!
    if @dead > 0
      Driver.game_over!
    if @target <= 0
      @complete = true
      Driver\killEnemies!

  draw: =>
    message = "seconds"
    num = math.floor @target
    if num == 1
      message = "second"
    @parent.message1 = "\t" .. num .. " " .. message .. " remaining!"
    super!
