export class EliminationWave extends Wave
  new: (parent, num) =>
    super parent
    @killed = 0
    @target = 0
    @queue = {}

    for i = 1, num
      num = math.random EnemyTypes.num_enemies
      enemy = ""
      value = 0
      if num == 1
        enemy = EnemyTypes.player
        value = 1
      elseif num == 2
        enemy = EnemyTypes.turret
        value = 1
      elseif num == 3
        enemy = EnemyTypes.spawner
        value = 5
      elseif num == 4
        enemy = EnemyTypes.strong
        value = 1
      else
        enemy = EnemyTypes.basic
        value = 1
      @target += value
      @queue[#@queue + 1] = enemy

--    for k, v in pairs @queue
--      print k .. ", " .. v

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
