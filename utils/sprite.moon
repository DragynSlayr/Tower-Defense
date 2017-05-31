-- Class for representing and drawing a Sprite
export class Sprite

  -- name: The path to the image file
  -- height: The height of the image
  -- width: The width of the image
  -- delay: The length of an animation cycle for this Sprite
  -- scale: How much to scale this Sprite by
  new: (name, height, width = height, delay = 1.0, scale = 1.0) =>
    -- Define flags for rendering
    flags = {}
    flags["linear"] = false
    flags["mipmaps"] = true

    -- Load the image
    @image = love.graphics.newImage("assets/sprites/" .. name, flags)

    -- Get number of frames
    @frames = @image\getWidth! / width

    -- Assign height and width
    @height, @width = height, width

    -- Scale image
    @x_scale, @y_scale = scale, scale
    @scaled_width, @scaled_height = @width * @x_scale, @height * @y_scale

    -- Load all images of this Sprite's animation
    @sprites = {}
    for i = 0, @frames - 1
      @sprites[i + 1] = love.graphics.newQuad i * @width, 0, @width, @height, @image\getDimensions!

    -- Variables for animation timings
    @time = 0
    @max_time = delay / @frames
    @current_frame = 1

    -- Variables for handling rotation
    @rotation = 0
    @rotation_speed = 0

  -- Set the color of the Sprite
  -- color: The color of the Sprite
  setColor: (color) =>
    -- Set the color
    @color = color

  -- Resize the Sprite
  -- x: The new x scale
  -- y: The new y scale
  setScale: (x, y) =>
    -- Set scale
    @x_scale = x
    @y_scale = y

    -- Recalculate scaled height and width
    @scaled_width = @width * @x_scale
    @scaled_height = @height * @y_scale

  -- Set the speed of rotation of this Sprite
  -- speed: The new rotation speed
  setRotationSpeed: (speed) =>
    -- Set the rotation speed
    @rotation_speed = speed

  -- Set the rotation of this Sprite
  -- angle: The new rotation of this Sprite
  setRotation: (angle) =>
    -- Set the rotation of the Sprite
    @rotation = angle

  -- Get the bounding circle of this Sprite
  -- x: The x position of this Sprite
  -- y: The y position of this Sprite
  getBounds: (x, y) =>
    -- Get the radius of this Sprite as the minimum of height and width
    radius = math.min @scaled_height / 2, @scaled_width / 2

    -- Return a new Circle at this x and y with the radius
    return Circle x, y, radius

  -- Update this Sprite
  -- dt: The time since the last update
  update: (dt) =>
    -- Update rotation
    @rotation += (math.pi * dt * @rotation_speed)

    -- Increment time
    @time += dt

    -- Check if new frame should be loaded
    if @time >= @max_time
      -- Reset time
      @time = 0

      -- Go to the next frame
      if @current_frame == @frames
        @current_frame = 1
      else
        @current_frame += 1

  -- Draw this Sprite
  -- x: X location of position to draw at
  -- y: Y location of position to draw at
  draw: (x, y) =>
    -- Store previous transforms
    love.graphics.push "all"

    if Driver.game_state == Game_State.playing or UI.current_screen == Screen_State.none
      love.graphics.setShader Driver.shader

    -- Color sprite if a color is set
    if @color
      love.graphics.setColor @color[1], @color[2], @color[3], @color[4]

    -- Draw the sprite
    love.graphics.draw @image, @sprites[@current_frame], math.floor(x), math.floor(y), @rotation, @x_scale, @y_scale, @width / 2, @height / 2

    -- Draw bounds if debugging
    if DEBUGGING
      love.graphics.setColor 0, 255, 0, 255
      circle = @getBounds x, y
      love.graphics.circle "line", circle.center.x, circle.center.y, circle.radius, 360

    -- Restore previous transforms
    if Driver.game_state == Game_State.playing or UI.current_screen == Screen_State.none
      love.graphics.setShader!
    love.graphics.pop!
