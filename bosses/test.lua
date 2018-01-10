do
  local _class_0
  local _parent_0 = Boss
  local _base_0 = {
    isVisible = function(self)
      return (((math.sin(self.fade_speed * self.ai_time)) + 1) / 2) >= self.threshold
    end,
    onCollide = function(self, object)
      if self:isVisible() then
        return _class_0.__parent.__base.onCollide(self, object)
      end
    end,
    update = function(self, dt)
      self.ai_time = self.ai_time + dt
      local visible = self:isVisible()
      self.solid = visible
      self.draw_health = visible
      self.alpha = ((math.sin(self.fade_speed * self.ai_time)) + 1) / 2
      self.sprite.shader:send("elapsed", ((math.sin(self.fade_speed * self.ai_time)) + 1) / 2)
      self.shader:send("player_pos", {
        self.target.position.x,
        self.target.position.y
      })
      local _exp_0 = self.ai_phase
      if 1 == _exp_0 then
        self.speed = Vector(self.target.position.x - self.position.x, self.target.position.y - self.position.y)
        self.speed:toUnitVector()
        self.speed = self.speed:multiply(self.speed_multiplier)
        _class_0.__parent.__base.update(self, dt)
        if self.ai_time >= 6 then
          self.ai_time = 0
          self.ai_phase = self.ai_phase + 1
          self.speed = Vector(0, 0)
          local speeds = {
            {
              0,
              1
            },
            {
              1,
              0
            },
            {
              -1,
              0
            },
            {
              0,
              -1
            },
            {
              1,
              1
            },
            {
              -1,
              -1
            },
            {
              -1,
              1
            },
            {
              1,
              -1
            }
          }
          for k, speed in pairs(speeds) do
            local copy = self.sprite:getCopy()
            copy:scaleUniformly(0.3)
            local b = SplitShot(self.position.x, self.position.y, (Vector(speed[1], speed[2])), 300 * Scale.diag, copy)
            b.sprite:setShader(love.graphics.newShader("shaders/normal.fs"))
            b.sprite:setColor({
              255,
              0,
              0,
              127
            })
            b.sprite:setRotationSpeed(math.pi * 1.5)
            Driver:addObject(b, EntityTypes.bullet)
          end
        end
      elseif 2 == _exp_0 then
        _class_0.__parent.__base.update(self, dt)
        if self.ai_time >= 7 then
          self.ai_time = 0
          self.ai_phase = 1
          local temp = Objectives:spawn((BossTest), EntityTypes.boss)
          self.position = temp.position
          return Driver:removeObject(temp, false)
        end
      end
    end,
    draw = function(self)
      local color = self.sprite.color
      color[4] = math.ceil((self.alpha * 255))
      self.sprite:setColor(color)
      return _class_0.__parent.__base.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("objective/portal.tga", 56, 56, 1, 1.8)
      _class_0.__parent.__init(self, x, y, sprite)
      self.bossType = BossTypes.test
      self.score_value = 1000
      self.exp_given = self.score_value + (self.score_value * 0.25 * Objectives:getLevel())
      self.health = 1000
      self.max_health = self.health
      self.max_speed = 225
      self.speed_multiplier = self.max_speed
      self.damage = 0.02
      self.sprite:setShader(love.graphics.newShader("shaders/pulse.fs"))
      self.sprite:setRotationSpeed(-math.pi / 2)
      self.shader = love.graphics.newShader("shaders/distance.fs")
      self.shader:send("screen_size", {
        Screen_Size.width,
        Screen_Size.height
      })
      if Driver.objects[EntityTypes.player] then
        for k, v in pairs(Driver.objects[EntityTypes.player]) do
          self.shader:send("player_pos", {
            v.position.x,
            v.position.y
          })
          self.target = v
          break
        end
      end
      self.ai_phase = 1
      self.ai_time = 0
      self.threshold = 0.1
      self.fade_speed = 1.5
      self.alpha = 0
    end,
    __base = _base_0,
    __name = "BossTest",
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
  BossTest = _class_0
end
