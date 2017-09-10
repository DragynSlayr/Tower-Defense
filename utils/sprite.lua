do
  local _class_0
  local _base_0 = {
    getCopy = function(self)
      local sprite = Sprite(self.name, self:getProperties())
      sprite.color = {
        self.color[1],
        self.color[2],
        self.color[3],
        self.color[4]
      }
      sprite.rotation_speed = self.rotation_speed
      sprite.rotation = self.rotation
      sprite.x_shear = self.x_shear
      sprite.y_shear = self.y_shear
      local x_scale = self.scaled_width / (self.width * Scale.width)
      local y_scale = self.scaled_height / (self.height * Scale.height)
      sprite:setScale(x_scale, y_scale)
      if self.shader then
        sprite:setShader(self.shader)
      end
      return sprite
    end,
    getProperties = function(self)
      return self.props[1], self.props[2], self.props[3], self.props[4]
    end,
    setColor = function(self, color)
      self.color = color
    end,
    setShear = function(self, x_shear, y_shear)
      self.x_shear = x_shear
      self.y_shear = y_shear
    end,
    setScale = function(self, x, y)
      if y == nil then
        y = x
      end
      self.x_scale = x * Scale.width
      self.y_scale = y * Scale.height
      self.scaled_width = self.width * self.x_scale
      self.scaled_height = self.height * self.y_scale
    end,
    scaleUniformly = function(self, scale)
      local x_scale = self.scaled_width / (self.width * Scale.width)
      local y_scale = self.scaled_height / (self.height * Scale.height)
      return self:setScale(x_scale * scale, y_scale * scale)
    end,
    setRotationSpeed = function(self, speed)
      self.rotation_speed = speed
    end,
    setRotation = function(self, angle)
      self.rotation = angle
    end,
    setShader = function(self, shader)
      self.shader = shader
      self.has_shader = true
      self.should_shade = true
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
      if Driver.game_state == Game_State.playing or UI.current_screen == Screen_State.none then
        if self.has_shader and self.should_shade then
          love.graphics.setShader(self.shader)
        else
          love.graphics.setShader(Driver.shader)
        end
      end
      love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.color[4])
      love.graphics.draw(self.image, self.sprites[self.current_frame], math.floor(x), math.floor(y), self.rotation, self.x_scale, self.y_scale, self.width / 2, self.height / 2, self.x_shear, self.y_shear)
      if Driver.game_state == Game_State.playing or UI.current_screen == Screen_State.none then
        love.graphics.setShader()
      end
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
      self.name = name
      self.props = {
        height,
        width,
        delay,
        scale
      }
      self.image = ResoureLoader:loadImage(PATH_PREFIX .. "assets/sprites/" .. name)
      self.frames = self.image:getWidth() / width
      self.height, self.width = height, width
      self.x_scale, self.y_scale = scale * Scale.width, scale * Scale.height
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
      self.color = {
        255,
        255,
        255,
        255
      }
      self.x_shear = 0
      self.y_shear = 0
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
