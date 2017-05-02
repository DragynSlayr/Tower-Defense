do
  local _class_0
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
      if i > 0 then
        print(i)
      end
      local x = math.random(love.graphics.getWidth())
      local y = math.random(love.graphics.getHeight())
      local enemy = BasicEnemy(x, y)
      local touching = false
      for k, v in pairs(Driver.objects) do
        for k2, o in pairs(v) do
          local object = o:getHitBox()
          local e = enemy:getHitBox()
          object.radius = object.radius + e.radius
          if object:contains(e.center) then
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
    update = function(self, dt)
      if self.waiting then
        self.elapsed = self.elapsed + dt
        if self.elapsed >= self.delay then
          self.spawnable = 14
          self.waiting = false
        end
      else
        if self.spawned + self.spawnable <= self.target then
          for i = 1, self.spawnable do
            self:spawn()
          end
          self.spawned = self.spawned + self.spawnable
          self.spawnable = 0
        end
      end
      if self.killed >= self.target then
        self.complete = true
      end
    end,
    draw = function(self)
      love.graphics.push("all")
      love.graphics.setColor(0, 0, 0, 255)
      local message = (self.target - self.killed) .. " enemies remaining!"
      Renderer:drawHUDMessage(message, 10, 10)
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, num)
      self.target = num
      self.killed = 0
      self.spawnable = 0
      self.elapsed = 0
      self.delay = 5
      self.waiting = true
      self.complete = false
      self.spawned = 0
    end,
    __base = _base_0,
    __name = "EliminationMode"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  EliminationMode = _class_0
end
