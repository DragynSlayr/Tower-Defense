export class Sprite
  new: (name, height, width = height, delay = 1.0, scale = 1.0) =>
    flags = {}
    flags["linear"] = false
    flags["mipmaps"] = true

    @image = love.graphics.newImage("assets/sprites/" .. name, flags)

    @frames = @image\getWidth! / width

    @height, @width = height, width
    @x_scale, @y_scale = scale, scale
    @scaled_width, @scaled_height = @width * @x_scale, @height * @y_scale

    @sprites = {}
    for i = 0, @frames - 1
      @sprites[i + 1] = love.graphics.newQuad i * @width, 0, @width, @height, @image\getDimensions!

    @time = 0
    @max_time = delay / @frames
    @current_frame = 1

    @rotation = 0
    @rotation_speed = 0

  setColor: (color) =>
    @color = color
    @colored = true

  setScale: (x, y) =>
    @x_scale = x
    @y_scale = y

    @scaled_width = @width * @x_scale
    @scaled_height = @height * @y_scale

  setRotationSpeed: (speed) =>
    @rotation_speed = speed

  setRotation: (angle) =>
    @rotation = angle

  getBounds: (x, y) =>
    radius = math.min @scaled_height / 2, @scaled_width / 2
    return Circle x, y, radius

  update: (dt) =>
    @rotation += (math.pi * dt * @rotation_speed)
    @time += dt

    if @time >= @max_time
      @time = 0
      if @current_frame == @frames
        @current_frame = 1
      else
        @current_frame += 1

  draw: (x, y) =>
    love.graphics.push "all"
    if @colored
      love.graphics.setColor @color[1], @color[2], @color[3], @color[4]
    love.graphics.draw @image, @sprites[@current_frame], math.floor(x), math.floor(y), @rotation, @x_scale, @y_scale, @width / 2, @height / 2
    if DEBUGGING
      love.graphics.setColor 0, 255, 0, 255
      circle = @getBounds x, y
      love.graphics.circle "line", circle.center.x, circle.center.y, circle.radius, 25
    love.graphics.pop!
