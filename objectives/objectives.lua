do
  local _class_0
  local _base_0 = {
    nextMode = function(self)
      self.counter = self.counter + 1
      if self.counter <= self.num_modes then
        self.mode = self.modes[self.counter]
        return self.mode:start()
      else
        self.counter = 0
        shuffle(self.modes)
        return self:nextMode()
      end
    end,
    entityKilled = function(self, entity)
      return self.mode:entityKilled(entity)
    end,
    update = function(self, dt)
      local start_difficulty = self.difficulty
      if not self.mode.complete then
        self.mode:update(dt)
        if self.mode.complete then
          local score = SCORE + (self.difficulty * 1000)
          SCORE = score
          self.mode:finish()
        end
      else
        self.elapsed = self.elapsed + dt
        if self.elapsed >= self.delay then
          self.elapsed = 0
          Driver.game_state = Game_State.upgrading
          UI:set_screen(Screen_State.upgrade)
        end
      end
      if start_difficulty ~= self.difficulty then
        local factor = (self.difficulty - 1) * 0.02
        self.basicChance = clamp(0.80 - factor, 0.20, 0.80)
        self.playerChance = clamp(0.05 + (factor / 4), 0.05, 0.20)
        self.turretChance = clamp(0.05 + (factor / 4), 0.05, 0.20)
        self.strongChance = clamp(0.05 + (factor / 4), 0.05, 0.20)
        self.spawnerChance = clamp(0.05 + (factor / 4), 0.05, 0.20)
      end
      Driver.shader = self.shader
    end,
    draw = function(self)
      if not self.mode.complete then
        return self.mode:draw()
      else
        love.graphics.push("all")
        Renderer:drawStatusMessage("Objective Complete!", love.graphics.getHeight() / 2, Renderer.title_font)
        return love.graphics.pop()
      end
    end,
    getLevel = function(self)
      local level = math.ceil(self.difficulty / 3)
      level = level - 1
      return level
    end,
    getRandomEnemy = function(self, basicChance, playerChance, turretChance, strongChance, spawnerChance)
      if basicChance == nil then
        basicChance = self.basicChance
      end
      if playerChance == nil then
        playerChance = self.playerChance
      end
      if turretChance == nil then
        turretChance = self.turretChance
      end
      if strongChance == nil then
        strongChance = self.strongChance
      end
      if spawnerChance == nil then
        spawnerChance = self.spawnerChance
      end
      local num = math.random()
      if num <= basicChance then
        return EnemyTypes.basic, 1
      elseif num <= basicChance + playerChance then
        return EnemyTypes.player, 1
      elseif num <= basicChance + playerChance + turretChance then
        return EnemyTypes.turret, 1
      elseif num <= basicChance + playerChance + turretChance + strongChance then
        return EnemyTypes.strong, 1
      else
        return EnemyTypes.spawner, 5
      end
    end,
    spawn = function(self, typeof, i)
      if i == nil then
        i = 0
      end
      local x = math.random(love.graphics.getWidth())
      local y = math.random(love.graphics.getHeight())
      local enemy
      local _exp_0 = typeof
      if EnemyTypes.player == _exp_0 then
        enemy = PlayerEnemy(x, y)
      elseif EnemyTypes.turret == _exp_0 then
        enemy = TurretEnemy(x, y)
      elseif EnemyTypes.spawner == _exp_0 then
        enemy = SpawnerEnemy(x, y)
      elseif EnemyTypes.strong == _exp_0 then
        enemy = StrongEnemy(x, y)
      elseif EnemyTypes.basic == _exp_0 then
        enemy = BasicEnemy(x, y)
      elseif GoalTypes.attack == _exp_0 then
        enemy = AttackGoal(x, y)
      elseif GoalTypes.defend == _exp_0 then
        enemy = DefendGoal(x, y)
      elseif GoalTypes.find == _exp_0 then
        enemy = FindGoal(x, y)
      end
      local touching = false
      for k, v in pairs(Driver.objects) do
        for k2, o in pairs(v) do
          local object = o:getHitBox()
          local e = enemy:getHitBox()
          if object:contains(e) then
            touching = true
            break
          end
        end
      end
      if touching or not enemy:isOnScreen(Screen_Size.border) then
        return self:spawn(typeof, i + 1)
      else
        if typeof == GoalTypes.attack or typeof == GoalTypes.defend or typeof == GoalTypes.find then
          return Driver:addObject(enemy, EntityTypes.goal)
        else
          return Driver:addObject(enemy, EntityTypes.enemy)
        end
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.mode = nil
      self.elapsed = 0
      self.delay = 3
      self.modes = {
        AttackMode(self),
        EliminationMode(self),
        DefendMode(self),
        DarkMode(self)
      }
      self.num_modes = #self.modes
      shuffle(self.modes)
      self.counter = 0
      self.difficulty = 0
      self.basicChance = 0.8
      self.playerChance = 0.05
      self.turretChance = 0.05
      self.strongChance = 0.05
      self.spawnerChance = 0.05
      self.shader = nil
    end,
    __base = _base_0,
    __name = "Objectives"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Objectives = _class_0
end
