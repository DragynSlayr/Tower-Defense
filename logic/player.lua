do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    keypressed = function(self, key)
      self.last_pressed = key
      local _exp_0 = key
      if "w" == _exp_0 then
        self.speed.x, self.speed.y = 0, -self.max_speed
      elseif "a" == _exp_0 then
        self.speed.x, self.speed.y = -self.max_speed, 0
      elseif "s" == _exp_0 then
        self.speed.x, self.speed.y = 0, self.max_speed
      elseif "d" == _exp_0 then
        self.speed.x, self.speed.y = self.max_speed, 0
      else
        self.speed.x, self.speed.y = self.speed.x, self.speed.y
      end
      if key == "space" then
        if self.show_turret then
          local turret = Turret(self.position.x, self.position.y, 250, Sprite("boss/shield.tga", 27, 26, 1, 2.5))
          if turret:isOnScreen() and self.num_turrets < self.max_turrets then
            Driver:addObject(turret, EntityTypes.turret)
            self.num_turrets = self.num_turrets + 1
            self.turret[#self.turret + 1] = turret
            self.show_turret = false
            self.max_turrets = self.max_turrets + 1
          end
        else
          if self.num_turrets ~= self.max_turrets then
            self.show_turret = true
          end
        end
      end
    end,
    keyreleased = function(self, key)
      self.last_released = key
      if key == "d" or key == "a" then
        self.speed.x = 0
      elseif key == "w" or key == "s" then
        self.speed.y = 0
      end
    end,
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      if self.show_turret then
        local turret = Turret(self.position.x, self.position.y, 250, Sprite("boss/shield.tga", 27, 26, 1, 2.5))
        return Renderer:enqueue((function()
          local _base_1 = turret
          local _fn_0 = _base_1.drawFaded
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)())
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, sprite)
      _class_0.__parent.__init(self, x, y, sprite)
      self.max_speed = 275
      self.max_turrets = 1
      self.num_turrets = 0
      self.turret = { }
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
