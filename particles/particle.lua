do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    setShader = function(self, shader, apply)
      if apply == nil then
        apply = false
      end
      self.sprite:setShader(shader)
      self.block_shader = apply
      self.sprite.should_shade = self.block_shader
    end,
    update = function(self, dt)
      if not self:isOnScreen(Screen_Size.border) then
        self.health = 0
        return 
      end
      if self.speed:getLength() > 0 then
        self.position:add(self.speed:multiply(dt))
      end
      self.sprite:update(dt)
      self.count = self.count + dt
      if self.count >= self.life_time then
        self.health = 0
      else
        self.alpha = self.alpha_start + ((self.alpha_end - self.alpha_start) * (self.count / self.life_time))
        local alpha = math.floor(self.alpha)
        self.sprite.color[4] = clamp(alpha, 0, 255)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, sprite, alpha_start, alpha_end, life_time)
      if alpha_start == nil then
        alpha_start = 255
      end
      if alpha_end == nil then
        alpha_end = 0
      end
      if life_time == nil then
        life_time = 1
      end
      _class_0.__parent.__init(self, x, y, sprite:getCopy())
      self.alpha = alpha_start
      self.alpha_start = alpha_start
      self.alpha_end = alpha_end
      self.draw_health = false
      self.id = EntityTypes.particle
      self.sprite.color[4] = self.alpha
      self.solid = false
      self.count = 0
      self.life_time = life_time
      return self:setShader(love.graphics.newShader("shaders/normal.fs"))
    end,
    __base = _base_0,
    __name = "Particle",
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
  Particle = _class_0
end
