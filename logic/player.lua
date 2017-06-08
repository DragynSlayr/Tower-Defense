do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    onCollide = function(self, object)
      if not self.alive then
        return 
      end
      if not self.shielded then
        if object.id == EntityTypes.enemy and object.enemyType == EnemyTypes.turret then
          self.health = self.health - (object.damage / 2)
        else
          self.health = self.health - object.damage
        end
        self.hit = true
      else
        self.shielded = false
      end
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
        if self.num_turrets ~= self.max_turrets then
          if self.can_place then
            self.show_turret = not self.show_turret
          end
        else
          if Upgrade.turret_special[4] then
            for k, v in pairs(self.turret) do
              local turret = v:getHitBox()
              local player = self:getHitBox()
              player.radius = player.radius + self.repair_range
              if turret:contains(player) then
                self.num_turrets = self.num_turrets - 1
                self.turret[k] = nil
                Driver:removeObject(v, false)
              end
            end
          end
        end
      elseif key == "space" then
        if self.show_turret then
          local turret = BasicTurret(self.position.x, self.position.y)
          if self.num_turrets < self.max_turrets then
            Driver:addObject(turret, EntityTypes.turret)
            self.num_turrets = self.num_turrets + 1
            self.turret[#self.turret + 1] = turret
            self.show_turret = false
            self.turret_count = self.turret_count - 1
            if self.turret_count == 0 then
              self.can_place = false
            end
            self.charged = false
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
        _class_0.__parent.__base.update(self, dt)
      else
        local start = Vector(self.speed.x, self.speed.y)
        local boost = Vector(self.speed_boost, 0)
        local angle = self.speed:getAngle()
        boost:rotate(angle)
        self.speed:add(boost)
        _class_0.__parent.__base.update(self, dt)
        self.speed = start
      end
      self.bomb_timer = self.bomb_timer + dt
      if self.bomb_timer >= self.max_bomb_time then
        self.bomb_timer = 0
        if Upgrade.player_special[3] then
          local x = math.random(Screen_Size.border[1], Screen_Size.border[3])
          local y = math.random(Screen_Size.border[2], Screen_Size.border[4])
          local bomb = PlayerBomb(x, y)
          Driver:addObject(bomb, EntityTypes.bomb)
        end
      end
      for k, bullet_position in pairs(self.globes) do
        bullet_position:rotate(dt * 1.25 * math.pi)
      end
      if self.turret_count ~= self.max_turrets then
        if self.elapsed >= self.turret_cooldown then
          self.elapsed = 0
          self.turret_count = clamp(self.turret_count + 1, 0, self.max_turrets)
          self.can_place = true
          self.charged = false
        end
      else
        self.elapsed = 0
        self.charged = true
      end
      self.speed_boost = 0
      self.attack_timer = self.attack_timer + dt
      local attacked = false
      if self.attack_timer >= self.attack_speed then
        if Driver.objects[EntityTypes.enemy] then
          for k, v in pairs(Driver.objects[EntityTypes.enemy]) do
            local enemy = v:getHitBox()
            local player = self:getHitBox()
            player.radius = player.radius + (self.attack_range + self.range_boost)
            if enemy:contains(player) then
              local bullet = PlayerBullet(self.position.x, self.position.y, v, self.damage)
              Driver:addObject(bullet, EntityTypes.bullet)
              attacked = true
              if Upgrade.player_special[4] then
                self.speed_boost = self.speed_boost + (self.max_speed / 2)
              end
            end
          end
        end
        if Driver.objects[EntityTypes.goal] then
          for k, v in pairs(Driver.objects[EntityTypes.goal]) do
            if v.goal_type == GoalTypes.attack then
              local goal = v:getHitBox()
              local player = self:getHitBox()
              player.radius = player.radius + (self.attack_range + self.range_boost)
              if goal:contains(player) then
                local bullet = PlayerBullet(self.position.x, self.position.y, v, self.damage)
                Driver:addObject(bullet, EntityTypes.bullet)
                attacked = true
              end
            else
              if v.goal_type == GoalTypes.find then
                local goal = v:getHitBox()
                local player = self:getHitBox()
                player.radius = player.radius * 1.25
                if goal:contains(player) then
                  v:onCollide(self)
                  attacked = true
                end
              end
            end
          end
        end
      end
      if attacked then
        self.attack_timer = 0
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
      local boosted = false
      for k, v in pairs(self.turret) do
        if Upgrade.player_special[2] then
          local turret = v:getHitBox()
          local player = self:getHitBox()
          player.radius = player.radius + (v.range / 5)
          if turret:contains(player) then
            boosted = true
          end
        end
        if not v.alive then
          self.num_turrets = self.num_turrets - 1
          self.turret[k] = nil
        end
      end
      if boosted then
        self.range_boost = self.attack_range
      else
        self.range_boost = 0
      end
    end,
    draw = function(self)
      if not self.alive then
        return 
      end
      if DEBUGGING then
        love.graphics.push("all")
        love.graphics.setColor(0, 0, 255, 100)
        local player = self:getHitBox()
        love.graphics.circle("fill", self.position.x, self.position.y, self.attack_range + player.radius + self.range_boost, 360)
        love.graphics.setColor(0, 255, 0, 100)
        love.graphics.circle("fill", self.position.x, self.position.y, self.speed_range, 360)
        love.graphics.pop()
      end
      _class_0.__parent.__base.draw(self)
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.setFont(self.font)
      local message = "Turret Cooldown"
      love.graphics.printf(message, 9 * Scale.width, Screen_Size.height - (47 * Scale.height) - self.font:getHeight() / 2, 205 * Scale.width, "center")
      local x_start = (9 * Scale.width)
      local remaining = clamp(self.elapsed, 0, self.turret_cooldown)
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.rectangle("fill", x_start + Scale.width, love.graphics.getHeight() - (30 * Scale.height), 200 * Scale.width, 20 * Scale.height)
      love.graphics.setColor(0, 0, 255, 255)
      local ratio = remaining / self.turret_cooldown
      if self.charged then
        ratio = 1
      end
      love.graphics.rectangle("fill", x_start + (4 * Scale.width), love.graphics.getHeight() - (27 * Scale.height), 194 * ratio * Scale.width, 14 * Scale.height)
      message = self.turret_count .. "/" .. self.max_turrets
      Renderer:drawHUDMessage(message, (x_start + 205) * Scale.width, Screen_Size.height - (30 * Scale.height), self.font)
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.rectangle("fill", (love.graphics.getWidth() / 2) - (200 * Scale.width), love.graphics.getHeight() - (30 * Scale.height), 400 * Scale.width, 20 * Scale.height)
      love.graphics.setColor(255, 0, 0, 255)
      ratio = self.health / self.max_health
      love.graphics.rectangle("fill", (love.graphics.getWidth() / 2) - (197 * Scale.width), love.graphics.getHeight() - (27 * Scale.height), 394 * ratio * Scale.width, 14 * Scale.height)
      Renderer:drawAlignedMessage("Player Health", Screen_Size.height - (47 * Scale.height), nil, self.font)
      if SHOW_RANGE then
        love.graphics.setColor(0, 255, 255, 255)
        for k, bullet_position in pairs(self.globes) do
          local boost = Vector(self.range_boost, 0)
          local angle = bullet_position:getAngle()
          boost:rotate(angle)
          local x = self.position.x + bullet_position.x + boost.x
          local y = self.position.y + bullet_position.y + boost.y
          love.graphics.circle("fill", x, y, 8 * Scale.diag, 360)
        end
      end
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
      self.attack_speed = Stats.player[5]
      self.health = self.max_health
      self.repair_range = 30 * Scale.diag
      self.keys_pushed = 0
      self.hit = false
      self.attack_timer = 0
      self.id = EntityTypes.player
      self.draw_health = false
      self.font = Renderer:newFont(20)
      self.can_place = true
      self.max_turrets = 1
      if Upgrade.turret_special[1] then
        self.max_turrets = 2
      end
      self.num_turrets = 0
      self.turret = { }
      self.range_boost = 0
      self.speed_boost = 0
      self.bomb_timer = 0
      self.max_bomb_time = 7
      self.speed_range = self.sprite:getBounds().radius + (150 * Scale.diag)
      self.turret_count = self.max_turrets
      self.charged = true
      self.globes = { }
      self.globe_index = 1
      local bounds = self:getHitBox()
      local width = bounds.radius + self.attack_range
      local num = 5
      for i = 1, num do
        local angle = ((math.pi * 2) / num) * i
        local vec = Vector(width, 0)
        vec:rotate(angle)
        self.globes[i] = Vector(vec.x, vec.y)
      end
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
