do
  local _class_0
  local _parent_0 = ActiveItem
  local _base_0 = {
    fire = function(self)
      local filters = {
        EntityTypes.enemy,
        EntityTypes.boss
      }
      for k2, filter in pairs(filters) do
        if Driver.objects[filter] then
          for k, v in pairs(Driver.objects[filter]) do
            print("B: " .. v.health)
            v:onCollide(self)
            print("A: " .. v.health)
          end
        end
      end
      self.effect_timer = 0
      self.damage = 0
      self.used = false
      self.player.movement_blocked = false
    end,
    pickup = function(self, player)
      _class_0.__parent.__base.pickup(self, player)
      self.damage_scale = player.damage * 10
    end,
    use = function(self)
      if self.used then
        return self:fire()
      elseif self.charged then
        self.timer = 0
        self.charged = false
        return self:effect(self.player)
      else
        return print("On Cooldown: " .. math.floor((self.charge_time - self.timer)))
      end
    end,
    update2 = function(self, dt)
      if self.used then
        self.effect_sprite:update(dt)
        self.effect_timer = self.effect_timer + dt
        self.damage = self.damage + (self.damage_scale * dt)
        print("Damage: " .. self.damage)
        if self.effect_timer >= self.effect_time then
          return self:fire()
        end
      else
        self.timer = self.timer + dt
        if not self.charged and self.timer >= self.charge_time then
          self.timer = 0
          self.charged = true
        end
      end
    end,
    draw2 = function(self)
      _class_0.__parent.__base.draw2(self)
      if self.used then
        love.graphics.push("all")
        love.graphics.setShader(Driver.shader)
        local filters = {
          EntityTypes.enemy,
          EntityTypes.boss
        }
        for k2, filter in pairs(filters) do
          if Driver.objects[filter] then
            for k, v in pairs(Driver.objects[filter]) do
              if v.health + v.armor <= self.damage then
                self.effect_sprite:draw(v.position.x, v.position.y)
              end
            end
          end
        end
        love.graphics.setShader()
        return love.graphics.pop()
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("item/deadeyeActive.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        self.used = true
        player.movement_blocked = true
        self.damage = 0
      end
      _class_0.__parent.__init(self, x, y, sprite, 10, effect)
      self.name = "Dead Eye"
      self.description = "Take aim and fire"
      self.used = false
      self.effect_time = 6
      self.effect_timer = 0
      self.damage = 0
      self.damage_scale = 1
      self.effect_sprite = Sprite("effect/deadeye.tga", 32, 32, 1, 1.75)
    end,
    __base = _base_0,
    __name = "DeadEyeActive",
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
  DeadEyeActive = _class_0
end
