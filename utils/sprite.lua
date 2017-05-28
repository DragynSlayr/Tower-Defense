do
  local _class_0
  local _base_0 = {
    setColor = function(self, color)
      self.color = color
    end,
    setScale = function(self, x, y)
      self.x_scale = x
      self.y_scale = y
      self.scaled_width = self.width * self.x_scale
      self.scaled_height = self.height * self.y_scale
    end,
    setRotationSpeed = function(self, speed)
      self.rotation_speed = speed
    end,
    setRotation = function(self, angle)
      self.rotation = angle
    end,
    getBounds = function(self, x, y)
      local radius = math.min(self.scaled_height / 2, self.scaled_width / 2)
      return Circle(x, y, radius)
    end,
    update = function(self, dt)
      self.rotation = self.rotation + (math.pi * dt * self.rotation_speed)
      self.time = self.time + dt
      if self.time >= self.max_time then
        self.time = 0
        if self.current_frame == self.frames then
          self.current_frame = 1
        else
          self.current_frame = self.current_frame + 1
        end
      end
    end,
    draw = function(self, x, y)
      love.graphics.push("all")
      love.graphics.setShader(Driver.shader)
      if self.color then
        love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.color[4])
      end
      love.graphics.draw(self.image, self.sprites[self.current_frame], math.floor(x), math.floor(y), self.rotation, self.x_scale, self.y_scale, self.width / 2, self.height / 2)
      if DEBUGGING then
        love.graphics.setColor(0, 255, 0, 255)
        local circle = self:getBounds(x, y)
        love.graphics.circle("line", circle.center.x, circle.center.y, circle.radius, 360)
      end
      love.graphics.setShader()
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, name, height, width, delay, scale)
      if width == nil then
        width = height
      end
      if delay == nil then
        delay = 1.0
      end
      if scale == nil then
        scale = 1.0
      end
      local flags = { }
      flags["linear"] = false
      flags["mipmaps"] = true
      self.image = love.graphics.newImage("assets/sprites/" .. name, flags)
      self.frames = self.image:getWidth() / width
      self.height, self.width = height, width
      self.x_scale, self.y_scale = scale, scale
      self.scaled_width, self.scaled_height = self.width * self.x_scale, self.height * self.y_scale
      self.sprites = { }
      for i = 0, self.frames - 1 do
        self.sprites[i + 1] = love.graphics.newQuad(i * self.width, 0, self.width, self.height, self.image:getDimensions())
      end
      self.time = 0
      self.max_time = delay / self.frames
      self.current_frame = 1
      self.rotation = 0
      self.rotation_speed = 0
    end,
    __base = _base_0,
    __name = "Sprite"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Sprite = _class_0
end
