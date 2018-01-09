do
  local _parent_0 = Wave
  local _base_0 = {
    start = function(self)
      if Driver.objects[EntityTypes.player] then
        for k, p in pairs(Driver.objects[EntityTypes.player]) do
          self.health = map(p.health, 0, p.max_health, 0, self.max_health)
          p.attack_range = Base_Stats.player[2]
        end
      end
      return self:respawnHearts()
    end,
    respawnHearts = function(self)
      Driver:clearObjects(EntityTypes.goal)
      for i = 1, 3 do
        self:spawnHeart(i > 1)
      end
    end,
    spawnHeart = function(self, isFake)
      if isFake == nil then
        isFake = false
      end
      local goal = Objectives:spawn((FindGoal), EntityTypes.goal)
      if isFake then
        local temp = FakeFindGoal(goal.position.x, goal.position.y)
        Driver:removeObject(goal, false)
        Driver:addObject(temp, EntityTypes.goal)
        goal = temp
      end
      goal.trail = ParticleEmitter(goal.position.x, goal.position.y, 1 / 60)
      goal.trail.position = Vector(Screen_Size.half_width, Screen_Size.half_height)
      goal.trail.shader = love.graphics.newShader("shaders/normal.fs")
      goal.trail.sprite = Sprite("particle/orb.tga", 32, 32, 1, 0.5)
      goal.trail.moving_particles = false
      goal.trail:setLifeTimeRange({
        0.25,
        0.75
      })
      return goal.trail:setSizeRange({
        0.1,
        1.0
      })
    end,
    entityKilled = function(self, entity)
      if entity.id == EntityTypes.goal then
        self.killed = self.killed + 1
        ScoreTracker:addScore(500)
        self.health = self.health + 6
        self.health = clamp(self.health, 0, self.max_health)
        self.heart_timer = self.heart_max_time
      end
    end,
    update = function(self, dt)
      if Driver.objects[EntityTypes.player] then
        for k, v in pairs(Driver.objects[EntityTypes.player]) do
          Objectives.shader:send("player_pos", {
            v.position.x,
            v.position.y
          })
          break
        end
      end
      _parent_0.update(self, dt)
      if not self.waiting then
        if Driver.objects[EntityTypes.player] then
          for k, v in pairs(Driver.objects[EntityTypes.player]) do
            self.health = self.health - (1 * dt)
            v.health = map(self.health, 0, self.max_health, 0, Stats.player[1])
            v.health = clamp(v.health, 0, v.max_health)
          end
        end
        if self.killed >= self.target then
          Driver:killEnemies()
          Driver:clearObjects(EntityTypes.goal)
          self.complete = true
          self.heart_timer = 0
          return 
        end
        self.heart_timer = self.heart_timer + dt
        if self.heart_timer >= self.heart_max_time then
          self.heart_timer = 0
          return self:respawnHearts()
        end
      end
    end,
    draw = function(self)
      local num = self.target - self.killed
      local message = "hearts"
      if num == 1 then
        message = "heart"
      end
      self.parent.message1 = "\t" .. num .. " " .. message .. " remaining!"
      return _parent_0.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, parent)
      _parent_0.__init(self, parent)
      self.killed = 0
      self.target = 3
      Objectives.shader = love.graphics.newShader("shaders/distance.fs")
      Objectives.shader:send("screen_size", Screen_Size.size)
      Objectives.shader:send("size", 10 - (0.5 * Upgrade.player_stats[2]))
      local a = math.log(Stats.player[1])
      local b = math.log(Base_Stats.player[1])
      self.max_health = 25 * (a / b)
      self.health = self.max_health
      self.heart_timer = 0
      local lower = clamp(((-4 / 30) * Objectives:getScaling()) + 5, 1, 5)
      self.heart_max_time = map(math.random(), 0, 1, lower, lower + 1)
    end,
    __base = _base_0,
    __name = "DarkWave",
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
  DarkWave = _class_0
end
