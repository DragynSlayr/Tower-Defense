do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    onCollide = function(self, entity)
      if entity.id == EntityTypes.enemy and entity.enemyType == EnemyTypes.capture then
        Driver:removeObject(entity, false)
        if self.enabled then
          self.health = self.health - entity.damage
        end
      else
        if self.enabled then
          _class_0.__parent.__base.onCollide(self, entity)
        end
      end
      if self.enabled then
        if math.random() < (0.25 / 60) then
          self.enabled = false
        end
        self.last_hit = entity.id
      end
    end,
    kill = function(self)
      _class_0.__parent.__base.kill(self)
      self.killer = self.last_hit
    end,
    update = function(self, dt)
      if self.health >= self.max_health then
        self.alive = false
      end
      if self.alive then
        _class_0.__parent.__base.update(self, dt)
      end
      self.lock_timer = self.lock_timer + dt
      if self.lock_timer >= self.disable_time and not self.enabled then
        self.lock_timer = 0
        self.enabled = true
      end
    end,
    draw = function(self)
      _class_0.__parent.__base.draw(self)
      love.graphics.push("all")
      if self.draw_health then
        love.graphics.setShader(Driver.shader)
        love.graphics.setColor(0, 0, 0, 255)
        local radius = self.sprite.scaled_height / 2
        love.graphics.rectangle("fill", (self.position.x - radius) - (3 * Scale.width), (self.position.y + radius) + (3 * Scale.height), (radius * 2) + (6 * Scale.width), 16 * Scale.height)
        if self.enabled then
          love.graphics.setColor(0, 127, 255, 255)
          local ratio = self.health / self.max_health
          love.graphics.rectangle("fill", self.position.x - radius, (self.position.y + radius) + (6 * Scale.height), (radius * 2) * ratio, 10 * Scale.height)
          love.graphics.setColor(255, 127, 0, 255)
          love.graphics.rectangle("fill", self.position.x - radius + ((radius * 2) * ratio), (self.position.y + radius) + (6 * Scale.height), (radius * 2) * (1 - ratio), 10 * Scale.height)
        else
          love.graphics.setColor(0, 255, 0, 255)
          love.graphics.rectangle("fill", self.position.x - radius, (self.position.y + radius) + (6 * Scale.height), radius * 2, 10 * Scale.height)
        end
        love.graphics.setShader()
      end
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("flag.tga", 34, 16, 1, 2.5)
      _class_0.__parent.__init(self, x, y, sprite)
      self.id = EntityTypes.goal
      self.goal_type = GoalTypes.capture
      self.health = 10 + (5.5 * Objectives:getLevel())
      self.max_health = self.health
      self.health = self.health / 2
      self.killer = nil
      self.last_hit = nil
      self.enabled = true
      self.lock_timer = 0
      self.disable_time = 5
    end,
    __base = _base_0,
    __name = "CaptureGoal",
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
  CaptureGoal = _class_0
end
