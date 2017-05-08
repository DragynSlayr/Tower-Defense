do
  local _class_0
  local _parent_0 = Mode
  local _base_0 = {
    entityKilled = function(self, entity)
      if entity.id == EntityTypes.enemy then
        self.killed = self.killed + 1
        if self.killed + 1 < self.target then
          self.spawnable = self.spawnable + 1
        end
      end
    end,
    spawn = function(self, i)
      if i == nil then
        i = 0
      end
      local x = math.random(love.graphics.getWidth())
      local y = math.random(love.graphics.getHeight())
      local num = math.random(5)
      local enemy
      local _exp_0 = num
      if 1 == _exp_0 then
        enemy = PlayerEnemy(x, y)
      elseif 2 == _exp_0 then
        enemy = TurretEnemy(x, y)
      elseif 3 == _exp_0 then
        enemy = SpawnerEnemy(x, y)
      elseif 4 == _exp_0 then
        enemy = StrongEnemy(x, y)
      else
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
        return self:spawn(i + 1)
      else
        return Driver:addObject(enemy, EntityTypes.enemy)
      end
    end,
    start = function(self)
      self.spawnable = math.min(4, self.target)
    end,
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      if not self.waiting then
        if self.spawned + self.spawnable <= self.target then
          for i = 1, self.spawnable do
            self:spawn()
          end
          self.spawned = self.spawned + self.spawnable
          self.spawnable = 0
        end
        if self.killed >= self.target then
          self.complete = true
        end
      end
    end,
    draw = function(self)
      self.message = "\t" .. (self.target - self.killed) .. " enemies remaining!"
      return _class_0.__parent.__base.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, num)
      _class_0.__parent.__init(self)
      self.target = num
      self.killed = 0
      self.spawnable = 0
      self.spawned = 0
    end,
    __base = _base_0,
    __name = "EliminationMode",
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
  EliminationMode = _class_0
end
