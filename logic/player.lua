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
        self.speed.x = self.speed.x - self.max_speed
      elseif key == "d" then
        self.speed.x = self.speed.x + self.max_speed
      elseif key == "w" then
        self.speed.y = self.speed.y - self.max_speed
      elseif key == "s" then
        self.speed.y = self.speed.y + self.max_speed
      end
      for k, v in pairs({
        "w",
        "a",
        "s",
        "d"
      }) do
        if key == v then
          self.keys_pushed = self.keys_pushed + 1
        end
      end
      if key == "q" then
        if DEBUGGING then
          local x = math.random(love.graphics.getWidth())
          local y = math.random(love.graphics.getHeight())
          local enemy = BasicEnemy(x, y)
          return Driver:addObject(enemy, EntityTypes.enemy)
        end
      elseif key == "e" then
        if self.num_turrets ~= self.max_turrets and self.can_place then
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
            self.can_place = false
            self.elapsed = 0
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
      if self.keys_pushed > 0 then
        if key == "a" then
          self.speed.x = self.speed.x + self.max_speed
        elseif key == "d" then
          self.speed.x = self.speed.x - self.max_speed
        elseif key == "w" then
          self.speed.y = self.speed.y + self.max_speed
        elseif key == "s" then
          self.speed.y = self.speed.y - self.max_speed
        end
        for k, v in pairs({
          "w",
          "a",
          "s",
          "d"
        }) do
          if key == v then
            self.keys_pushed = self.keys_pushed - 1
          end
        end
      end
    end,
    update = function(self, dt)
      if not self.alive then
        return 
      end
      if self.keys_pushed == 0 then
        self.speed = Vector(0, 0)
      end
      _class_0.__parent.__base.update(self, dt)
      if self.elapsed > self.turret_cooldown then
        self.can_place = true
      end
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
      _class_0.__parent.__base.draw(self)
      local remaining = MathHelper:clamp(self.turret_cooldown - self.elapsed, 0, self.turret_cooldown)
      remaining = math.floor(remaining)
      local message = ""
      if remaining == 0 or self.can_place then
        message = "Turret Available!"
      else
        message = "Turret Cooldown " .. remaining .. " seconds"
      end
      return Renderer:drawAlignedMessage(message, 30, "right")
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
      self.attack_range = 75
      self.max_speed = 275
      self.max_turrets = 1
      self.num_turrets = 0
      self.turret = { }
      self.id = EntityTypes.player
      self.repair_range = 30
      self.can_place = true
      self.turret_cooldown = 20
      self.keys_pushed = 0
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
