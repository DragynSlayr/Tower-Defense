do
  local _class_0
  local _parent_0 = Wave
  local _base_0 = {
    getRandomEnemy = function(self, basicChance, playerChance, turretChance, strongChance, spawnerChance)
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
    entityKilled = function(self, entity)
      if entity.id == EntityTypes.enemy or entity.enemyType then
        self.killed = self.killed + 1
        if #self.queue ~= 0 then
          local enemy = self.queue[1]
          self:spawn(enemy)
          return table.remove(self.queue, 1)
        end
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
      if touching then
        return self:spawn(typeof, i + 1)
      else
        return Driver:addObject(enemy, EntityTypes.enemy)
      end
    end,
    start = function(self)
      local num = math.min(4, #self.queue)
      for i = 1, num do
        local enemy = self.queue[1]
        self:spawn(enemy)
        table.remove(self.queue, 1)
      end
    end,
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      if self.killed == self.target then
        self.complete = true
      end
    end,
    draw = function(self)
      self.parent.message1 = "\t" .. (self.target - self.killed) .. " enemies remaining!"
      return _class_0.__parent.__base.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, num, difficulty)
      _class_0.__parent.__init(self, parent)
      self.killed = 0
      self.target = 0
      self.queue = { }
      for i = 1, num do
        local factor = (difficulty - 1) * 0.02
        self.basicChance = MathHelper:clamp(0.80 - factor, 0.20, 0.80)
        self.playerChance = MathHelper:clamp(0.05 + (factor / 4), 0.05, 0.20)
        self.turretChance = MathHelper:clamp(0.05 + (factor / 4), 0.05, 0.20)
        self.strongChance = MathHelper:clamp(0.05 + (factor / 4), 0.05, 0.20)
        self.spawnerChance = MathHelper:clamp(0.05 + (factor / 4), 0.05, 0.20)
        local enemy, value = self:getRandomEnemy(self.basicChance, self.playerChance, self.turretChance, self.strongChance, self.spawnerChance)
        self.target = self.target + value
        self.queue[#self.queue + 1] = enemy
      end
    end,
    __base = _base_0,
    __name = "EliminationWave",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  EliminationWave = _class_0
end
