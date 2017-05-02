do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    keypressed = function(self, key)
      if not self.alive then
        return 
      end
      self.last_pressed = key
      if key == "a" then
        self.speed.x = -self.max_speed
      elseif key == "d" then
        self.speed.x = self.max_speed
      elseif key == "w" then
        self.speed.y = -self.max_speed
      elseif key == "s" then
        self.speed.y = self.max_speed
      end
      if key == "q" then
        if DEBUGGING then
          local x = math.random(love.graphics.getWidth())
          local y = math.random(love.graphics.getHeight())
          local enemy = BasicEnemy(x, y)
          return Driver:addObject(enemy, EntityTypes.enemy)
        end
      elseif key == "e" then
        if self.num_turrets ~= self.max_turrets then
          self.show_turret = not self.show_turret
        end
      elseif key == "space" then
        if self.show_turret then
          local turret = BasicTurret(self.position.x, self.position.y)
          if self.num_turrets < self.max_turrets then
            Driver:addObject(turret, EntityTypes.turret)
            self.num_turrets = self.num_turrets + 1
            self.turret[#self.turret + 1] = turret
            self.show_turret = false
          end
        end
        if self.turret then
          for k, v in pairs(self.turret) do
            local turret = v:getHitBox()
            local player = self:getHitBox()
            turret.radius = turret.radius + (player.radius + self.repair_range)
            if turret:contains(player.center) then
              v.health = v.health + 0.6
              v.health = MathHelper:clamp(v.health, 0, v.max_health)
            end
          end
        end
      end
    end,
    keyreleased = function(self, key)
      if not self.alive then
        return 
      end
      self.last_released = key
      if key == "d" or key == "a" then
        self.speed.x = 0
      elseif key == "w" or key == "s" then
        self.speed.y = 0
      end
    end,
    update = function(self, dt)
      if not self.alive then
        return 
      end
      _class_0.__parent.__base.update(self, dt)
      if Driver.objects[EntityTypes.enemy] then
        for k, v in pairs(Driver.objects[EntityTypes.enemy]) do
          local enemy = v:getHitBox()
          local player = self:getHitBox()
          enemy.radius = enemy.radius + (player.radius + self.attack_range)
          if enemy:contains(player.center) then
            local bullet = PlayerBullet(self.position.x, self.position.y, v)
            Driver:addObject(bullet, EntityTypes.bullet)
          end
        end
      end
      if self.show_turret then
        local turret = BasicTurret(self.position.x, self.position.y)
        Renderer:enqueue((function()
          local _base_1 = turret
          local _fn_0 = _base_1.drawFaded
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)())
      end
      for k, v in pairs(self.turret) do
        if not v.alive then
          self.num_turrets = self.num_turrets - 1
          self.turret[k] = nil
        end
      end
    end,
    draw = function(self)
      if not self.alive then
        return 
      end
      if DEBUGGING then
        love.graphics.push("all")
        love.graphics.setColor(0, 0, 255, 255)
        local player = self:getHitBox()
        love.graphics.circle("fill", self.position.x, self.position.y, self.attack_range + player.radius, 25)
        love.graphics.pop()
      end
      return _class_0.__parent.__base.draw(self)
    end,
    kill = function(self)
      _class_0.__parent.kill(self)
      local player = Player(self.position.x, self.position.y, self.sprite)
      return Driver:addObject(player, EntityTypes.player)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, sprite)
      _class_0.__parent.__init(self, x, y, sprite)
      self.attack_range = 35
      self.max_speed = 275
      self.max_turrets = 1
      self.num_turrets = 0
      self.turret = { }
      self.id = EntityTypes.player
      self.repair_range = 30
    end,
    __base = _base_0,
    __name = "Player",
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
  Player = _class_0
end
