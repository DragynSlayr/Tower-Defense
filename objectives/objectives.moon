export class ObjectivesHandler
  new: =>
    @mode = nil
    @elapsed = 0
    @delay = 3
    @modes = {
      AttackMode @,
      EliminationMode @,
      DefendMode @,
      DarkMode @,
      CaptureMode @
    }
    @boss_mode = BossMode @
    @num_modes = #@modes
    shuffle @modes
    @counter = 0
    @difficulty = 0
    @basicChance = 0.8
    @playerChance = 0.05
    @turretChance = 0.05
    @strongChance = 0.05
    @spawnerChance = 0.05
    @shader = nil
    @ready = false

  nextMode: =>
    @counter += 1
    if @counter <= @num_modes
      @mode = @modes[@counter]
    else
      @counter = 0
      shuffle @modes
      --@nextMode!
      -- Boss Wave
      @mode = @boss_mode
    @mode\start!

  entityKilled: (entity) =>
    @mode\entityKilled entity

  update: (dt) =>
    start_difficulty = @difficulty
    if not @mode.complete
      @mode\update dt
      if @mode.complete
        ScoreTracker\addScore 5000
        @mode\finish!
    else
      @elapsed += dt
      if @elapsed >= @delay and @ready
        @ready = false
        @elapsed = 0
        Driver.game_state = Game_State.upgrading
        UI\set_screen Screen_State.upgrade
    if start_difficulty ~= @difficulty
      factor = (@difficulty - 1) * 0.02
      @basicChance = clamp 0.80 - factor, 0.20, 0.80
      @playerChance = clamp 0.05 + (factor / 4), 0.05, 0.20
      @turretChance = clamp 0.05 + (factor / 4), 0.05, 0.20
      @strongChance = clamp 0.05 + (factor / 4), 0.05, 0.20
      @spawnerChance = clamp 0.05 + (factor / 4), 0.05, 0.20
    Driver.shader = @shader

  draw: =>
    if not @mode.complete
      @mode\draw!
    else
      love.graphics.push "all"
      Renderer\drawStatusMessage "Objective Complete!", Screen_Size.half_height, Renderer.title_font, Color 255, 255, 255, 255
      Renderer\drawStatusMessage "Press space to continue", Screen_Size.half_height + (70 * Scale.height), Renderer.title_font, Color 255, 255, 255, 255
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

  spawn: (typeof, i = 0, x = nil, y = nil) =>
    if not x
      x = math.random love.graphics.getWidth!
    if not y
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
      when EnemyTypes.capture
        CaptureEnemy x, y
      when GoalTypes.attack
        AttackGoal x, y
      when GoalTypes.defend
        DefendGoal x, y
      when GoalTypes.find
        FindGoal x, y
      when GoalTypes.tesseract
        TesseractGoal x, y
      when EntityTypes.player
        Player x, y
      when BossTypes.vyder
        BossVyder x, y
    touching = false
    for k, v in pairs Driver.objects
      for k2, o in pairs v
        object = o\getHitBox!
        e = enemy\getHitBox!
        if object\contains e
          touching = true
          break
    if touching or not enemy\isOnScreen Screen_Size.border
      @spawn typeof, i + 1
    elseif typeof == EntityTypes.player
      Driver\addObject enemy, EntityTypes.player
      return enemy
    else
      if tableContains GoalTypes, typeof
        Driver\addObject enemy, EntityTypes.goal
        return enemy
      elseif tableContains BossTypes, typeof
        Driver\addObject enemy, EntityTypes.boss
        return enemy
      else
        Driver\addObject enemy, EntityTypes.enemy
        return enemy
