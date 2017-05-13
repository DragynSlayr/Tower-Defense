do
  local _class_0
  local _parent_0 = Wave
  local _base_0 = {
    spawnRandomEnemy = function(self)
      local spawnerChance = self.parent.parent.spawnerChance / 4
      local basicChance = self.parent.parent.basicChance + spawnerChance
      local playerChance = self.parent.parent.playerChance + spawnerChance
      local turretChance = self.parent.parent.turretChance + spawnerChance
      local strongChance = self.parent.parent.strongChance + spawnerChance
      return self.parent.parent:spawn(self.parent.parent:getRandomEnemy(basicChance, playerChance, turretChance, strongChance, 0))
    end,
    start = function(self)
      for i = 1, self.parent.parent.difficulty do
        self.parent.parent:spawn(GoalTypes.attack)
      end
    end,
    entityKilled = function(self, entity)
      if entity.id == EntityTypes.goal then
        self.killed = self.killed + 1
        return self:spawnRandomEnemy()
      end
    end,
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      if not self.waiting then
        self.elapsed = self.elapsed + dt
        if self.elapsed >= self.max_time and self.killed ~= self.target then
          self.elapsed = 0
          self.spawn_count = self.spawn_count + 1
          self.max_time = (3 / self.spawn_count) + (5 / 3)
          self:spawnRandomEnemy()
        end
      end
      if self.killed == self.target and Driver:isClear() then
        self.complete = true
      end
    end,
    draw = function(self)
      local num = self.target - self.killed
      local message = "beacons"
      if num == 1 then
        message = "beacon"
      end
      self.parent.message1 = "\t" .. num .. " " .. message .. " remaining!"
      return _class_0.__parent.__base.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      _class_0.__parent.__init(self, parent)
      self.killed = 0
      self.target = self.parent.parent.difficulty
      self.spawn_count = self.target
      self.max_time = (3 / self.spawn_count) + (5 / 3)
    end,
    __base = _base_0,
    __name = "AttackWave",
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
  AttackWave = _class_0
end
