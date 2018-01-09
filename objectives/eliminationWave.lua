do
  local _parent_0 = Wave
  local _base_0 = {
    entityKilled = function(self, entity)
      if entity.id == EntityTypes.enemy or entity.enemyType then
        self.killed = self.killed + 1
        self.to_spawn = self.to_spawn + entity.value
        while self.to_spawn >= 1 and #self.queue ~= 0 do
          local enemy = self.queue[1]
          Objectives:spawn((enemy), EntityTypes.enemy)
          table.remove(self.queue, 1)
          self.to_spawn = self.to_spawn - 1
        end
      end
    end,
    start = function(self)
      local num = math.min(4, #self.queue)
      for i = 1, num do
        local enemy = self.queue[1]
        Objectives:spawn((enemy), EntityTypes.enemy)
        table.remove(self.queue, 1)
      end
    end,
    update = function(self, dt)
      _parent_0.update(self, dt)
      if self.killed >= self.target then
        Driver:killEnemies()
        self.complete = true
      end
    end,
    draw = function(self)
      local num = self.target - self.killed
      local message = "enemies"
      if num == 1 then
        message = "enemy"
      end
      self.parent.message1 = "\t" .. num .. " " .. message .. " remaining!"
      return _parent_0.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, parent, num)
      _parent_0.__init(self, parent)
      self.killed = 0
      self.target = 0
      self.queue = { }
      self.to_spawn = 0
      for i = 1, num do
        local enemy, value = Objectives:getRandomEnemy()
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
        return _parent_0[name]
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
