export class Objectives
  new: =>
    @mode = nil
    @elapsed = 0
    @delay = 10
    @modes = {
      AttackMode @,
      EliminationMode @
    }
    @num_modes = #@modes
    MathHelper\shuffle @modes
    @counter = 0
    @difficulty = 0
    @basicChance = 0.8
    @playerChance = 0.05
    @turretChance = 0.05
    @strongChance = 0.05
    @spawnerChance = 0.05

  nextMode: =>
    @counter += 1
    if @counter <= @num_modes
      @mode = @modes[@counter]
      @mode\start!
    else
      @counter = 0
      MathHelper\shuffle @modes
      -- Boss Wave
      @nextMode!

  entityKilled: (entity) =>
    @mode\entityKilled entity

  update: (dt) =>
    start_difficulty = @difficulty
    if not @mode.complete
      @mode\update dt
      if @mode.complete
        score = SCORE + (@difficulty * 1000)
        export SCORE = score
    else
      @elapsed += dt
      if @elapsed >= @delay
        @elapsed = 0
        @nextMode!
    if start_difficulty ~= @difficulty
      factor = (@difficulty - 1) * 0.02
      @basicChance = MathHelper\clamp 0.80 - factor, 0.20, 0.80
      @playerChance = MathHelper\clamp 0.05 + (factor / 4), 0.05, 0.20
      @turretChance = MathHelper\clamp 0.05 + (factor / 4), 0.05, 0.20
      @strongChance = MathHelper\clamp 0.05 + (factor / 4), 0.05, 0.20
      @spawnerChance = MathHelper\clamp 0.05 + (factor / 4), 0.05, 0.20

  draw: =>
    if not @mode.complete
      @mode\draw!
    else
      love.graphics.push "all"
      Renderer\drawStatusMessage "Objective Complete!", love.graphics.getHeight! / 2, Renderer.title_font
      love.graphics.pop!

  getLevel: =>
    level = math.ceil @difficulty / 3
    level -= 1
    return level

  getRandomEnemy: (basicChance = @basicChance, playerChance = @playerChance, turretChance = @turretChance, strongChance = @strongChance, spawnerChance = @spawnerChance) =>
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
      when GoalTypes.attack
        AttackGoal x, y
      when GoalTypes.defend
        DefendGoal x, y
    touching = false
    for k, v in pairs Driver.objects
      for k2, o in pairs v
        object = o\getHitBox!
        e = enemy\getHitBox!
        if object\contains e
          touching = true
          break
    if touching or not enemy\isOnScreen 20
      @spawn typeof, i + 1
    else
      if typeof == GoalTypes.attack or typeof == GoalTypes.defend
        Driver\addObject enemy, EntityTypes.goal
      else
        --print enemy\__tostring!
        Driver\addObject enemy, EntityTypes.enemy
