do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    onCollide = function(self, object)
      if not self.alive then
        return 
      end
      if object.id == EntityTypes.enemy and object.enemyType == EnemyTypes.turret then
        self.health = self.health - (object.damage / 2)
      else
        self.health = self.health - object.damage
      end
      self.hit = true
    end,
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
            player.radius = player.radius + self.repair_range
            if turret:contains(player) then
              v.health = v.health + 1
              v.health = clamp(v.health, 0, v.max_health)
            end
          end
        end
      elseif key == "z" then
        SHOW_RANGE = not SHOW_RANGE
      elseif key == "`" then
        DEBUGGING = not DEBUGGING
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
          player.radius = player.radius + self.attack_range
          if enemy:contains(player) then
            local bullet = PlayerBullet(self.position.x, self.position.y, v, self.damage)
            Driver:addObject(bullet, EntityTypes.bullet)
          end
        end
      end
      if Driver.objects[EntityTypes.goal] then
        for k, v in pairs(Driver.objects[EntityTypes.goal]) do
          if v.goal_type == GoalTypes.attack then
            local goal = v:getHitBox()
            local player = self:getHitBox()
            player.radius = player.radius + self.attack_range
            if goal:contains(player) then
              local bullet = PlayerBullet(self.position.x, self.position.y, v, self.damage)
              Driver:addObject(bullet, EntityTypes.bullet)
            end
          else
            if v.goal_type == GoalTypes.find then
              local goal = v:getHitBox()
              local player = self:getHitBox()
              player.radius = player.radius + 5
              if goal:contains(player) then
                v:onCollide(self)
              end
            end
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
      if DEBUGGING or SHOW_RANGE then
        love.graphics.push("all")
        love.graphics.setColor(0, 0, 255, 100)
        local player = self:getHitBox()
        love.graphics.circle("fill", self.position.x, self.position.y, self.attack_range + player.radius, 360)
        love.graphics.pop()
      end
      _class_0.__parent.__base.draw(self)
      local message = " Turret CD  "
      Renderer:drawHUDMessage(message, (9 * Scale.width), Screen_Size.height - (52 * Scale.height), self.font)
      local x_start = (9 * Scale.width) + self.font:getWidth(message)
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.rectangle("fill", x_start, love.graphics.getHeight() - (52 * Scale.height), 202 * Scale.width, 43 * Scale.height)
      local remaining = clamp(self.turret_cooldown - self.elapsed, 0, self.turret_cooldown)
      remaining = math.floor(remaining)
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.rectangle("fill", x_start + Scale.width, love.graphics.getHeight() - (51 * Scale.height), 200 * Scale.width, 20 * Scale.height)
      love.graphics.setColor(0, 0, 255, 255)
      local ratio = 1 - (remaining / self.turret_cooldown)
      if remaining == 0 or self.can_place then
        ratio = 1
      end
      love.graphics.rectangle("fill", x_start + (4 * Scale.width), love.graphics.getHeight() - (48 * Scale.height), 194 * ratio * Scale.width, 14 * Scale.height)
      local turret_health = 0
      local num = 0
      if Driver.objects[EntityTypes.turret] then
        for k, t in pairs(Driver.objects[EntityTypes.turret]) do
          turret_health = turret_health + t.health
          num = num + t.max_health
        end
      else
        turret_health = 1
        num = 1
      end
      ratio = turret_health / num
      message = " Turret HP  "
      Renderer:drawHUDMessage(message, (9 * Scale.width), Screen_Size.height - (30 * Scale.height), self.font)
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.rectangle("fill", x_start + Scale.width, love.graphics.getHeight() - (30 * Scale.height), 200 * Scale.width, 20 * Scale.height)
      love.graphics.setColor(0, 255, 0, 255)
      love.graphics.rectangle("fill", x_start + (4 * Scale.width), love.graphics.getHeight() - (27 * Scale.height), 194 * ratio * Scale.width, 14 * Scale.height)
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.rectangle("fill", (love.graphics.getWidth() / 2) - (200 * Scale.width), love.graphics.getHeight() - (30 * Scale.height), 400 * Scale.width, 20 * Scale.height)
      love.graphics.setColor(255, 0, 0, 255)
      ratio = self.health / self.max_health
      love.graphics.rectangle("fill", (love.graphics.getWidth() / 2) - (197 * Scale.width), love.graphics.getHeight() - (27 * Scale.height), 394 * ratio * Scale.width, 14 * Scale.height)
      return Renderer:drawAlignedMessage("Player Health", Screen_Size.height - (47 * Scale.height), nil, self.font)
    end,
    kill = function(self)
      _class_0.__parent.kill(self)
      return Driver.game_over()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("test.tga", 16, 16, 0.29, 4)
      _class_0.__parent.__init(self, x, y, sprite)
      self.sprite:setRotationSpeed(-math.pi / 2)
      self.max_health = Stats.player[1]
      self.attack_range = Stats.player[2]
      self.damage = Stats.player[3]
      self.max_speed = Stats.player[4]
      self.turret_cooldown = Stats.turret[4]
      self.health = self.max_health
      self.repair_range = 30 * Scale.diag
      self.keys_pushed = 0
      self.hit = false
      self.id = EntityTypes.player
      self.draw_health = false
      self.can_place = true
      self.max_turrets = 1
      self.num_turrets = 0
      self.turret = { }
      self.font = Renderer:newFont(20)
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
