do
  local _class_0
  local _parent_0 = Wave
  local _base_0 = {
    start = function(self)
      for i = 1, self.target do
        local goal = self.parent.parent:spawn(GoalTypes.find)
        if false then
          local delay = love.math.random(2, 4)
          local life_time = math.random()
          local em = ParticleEmitter(0, 0, delay, life_time, goal)
          em.shader = love.graphics.newShader("shaders/normal.fs")
          em.sprite = Sprite("orb.tga", 32, 32, 1, 0.5)
          Driver:addObject(em, EntityTypes.particle)
        end
      end
      if Driver.objects[EntityTypes.player] then
        for k, p in pairs(Driver.objects[EntityTypes.player]) do
          p.attack_range = Base_Stats.player[2]
        end
      end
    end,
    entityKilled = function(self, entity)
      if entity.id == EntityTypes.goal then
        self.killed = self.killed + 1
        local score = SCORE + 500
        SCORE = score
        self.health = self.health + 6
        self.health = clamp(self.health, 0, self.max_health)
      end
    end,
    update = function(self, dt)
      if Driver.objects[EntityTypes.player] then
        for k, v in pairs(Driver.objects[EntityTypes.player]) do
          self.parent.parent.shader:send("player_pos", {
            v.position.x,
            v.position.y
          })
        end
      end
      _class_0.__parent.__base.update(self, dt)
      if not self.waiting then
        if Driver.objects[EntityTypes.player] then
          for k, v in pairs(Driver.objects[EntityTypes.player]) do
            self.health = self.health - (1 * dt)
            v.health = map(self.health, 0, self.max_health, 0, Stats.player[1])
            v.health = clamp(v.health, 0, v.max_health)
          end
        end
      end
      if self.killed >= self.target then
        Driver:killEnemies()
        self.complete = true
      end
    end,
    draw = function(self)
      local num = self.target - self.killed
      local message = "hearts"
      if num == 1 then
        message = "heart"
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
      self.target = self.parent.wave_count
      self.parent.parent.shader = love.graphics.newShader("shaders/distance.fs")
      self.parent.parent.shader:send("screen_size", Screen_Size.size)
      self.parent.parent.shader:send("size", 10 - (0.5 * Upgrade.player_stats[2]))
      local a = math.log(Stats.player[1])
      local b = math.log(Base_Stats.player[1])
      self.max_health = 25 * (a / b)
      self.health = self.max_health
      if Driver.objects[EntityTypes.player] then
        for k, p in pairs(Driver.objects[EntityTypes.player]) do
          self.health = map(p.health, 0, p.max_health, 0, self.max_health)
        end
      end
    end,
    __base = _base_0,
    __name = "DarkWave",
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
  DarkWave = _class_0
end
