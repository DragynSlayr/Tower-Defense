export class EliminationWave extends Wave
  new: (parent, num, difficulty) =>
    super parent
    @killed = 0
    @target = 0
    @queue = {}

    for i = 1, num
      factor = (difficulty - 1) * 0.02
      @basicChance = MathHelper\clamp 0.80 - factor, 0.20, 0.80
      @playerChance = MathHelper\clamp 0.05 + (factor / 4), 0.05, 0.20
      @turretChance = MathHelper\clamp 0.05 + (factor / 4), 0.05, 0.20
      @strongChance = MathHelper\clamp 0.05 + (factor / 4), 0.05, 0.20
      @spawnerChance = MathHelper\clamp 0.05 + (factor / 4), 0.05, 0.20
      enemy, value = @getRandomEnemy @basicChance, @playerChance, @turretChance, @strongChance, @spawnerChance
      
      @target += value
      @queue[#@queue + 1] = enemy

--    for k, v in pairs @queue
--      print k .. ", " .. v

--    print difficulty .. ": " .. @basicChance .. " " .. @playerChance .. " " .. @turretChance .. " " .. @strongChance .. " " .. @spawnerChance .. "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

  getRandomEnemy: (basicChance, playerChance, turretChance, strongChance, spawnerChance) =>
    num = math.random!
    if num <= basicChance
      return EnemyTypes.basic, 1
    elseif num <= basicChance + playerChance
      return EnemyTypes.player, 1
    elseif num <= basicChance + playerChance + turretChance
      return EnemyTypes.turret, 1
    elseif num <= basicChance + playerChance + turretChance + strongChance
      return EnemyTypes.strong, 1
    else
      return EnemyTypes.spawner, 5

  entityKilled: (entity) =>
    if entity.id == EntityTypes.enemy or entity.enemyType
      @killed += 1
      if #@queue ~= 0
        enemy = @queue[1]
--        print "Spawning: " .. enemy
        @spawn enemy
        table.remove @queue, 1

  spawn: (typeof, i = 0) =>
    x = math.random love.graphics.getWidth!
    y = math.random love.graphics.getHeight!
    enemy = switch typeof
      when EnemyTypes.player
        PlayerEnemy x, y
      when EnemyTypes.turret
        TurretEnemy x, y
      when EnemyTypes.spawner
        SpawnerEnemy x, y
      when EnemyTypes.strong
        StrongEnemy x, y
      when EnemyTypes.basic
        BasicEnemy x, y
    touching = false
    for k, v in pairs Driver.objects
      for k2, o in pairs v
        object = o\getHitBox!
        e = enemy\getHitBox!
        if object\contains e
          touching = true
          break
    if touching
      @spawn typeof, i + 1
    else
      Driver\addObject enemy, EntityTypes.enemy

  start: =>
    num = math.min 4, #@queue
    for i = 1, num
      enemy = @queue[1]
--      print "Spawning: " .. enemy
      @spawn enemy
      table.remove @queue, 1


  update: (dt) =>
    super dt
    if @killed == @target
      @complete = true

  draw: =>
    @parent.message1 = "\t" .. (@target - @killed) .. " enemies remaining!"
    super!
