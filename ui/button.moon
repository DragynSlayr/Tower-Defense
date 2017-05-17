-- Class for representing a Button
export class Button

  -- x: X coordinate of the Button
  -- y: Y coordinate of the Button
  -- width: Width of the Button
  -- height: Height of the Button
  -- text: Text to be shown on the Button
  -- action: Function to execute when the Button is clicked
  new: (x, y, width, height, text, action) =>
    -- Store values
    @x = x
    @y = y
    @width = width
    @height = height
    @text = text
    @action = action

    -- State of the Button
    @idle_color = {175, 175, 175, 255}
    @hover_color = {100, 100, 100, 255}
    @selected = false
    @clickable = true

    -- Timing of the Button
    @elapsed = 0
    @max_time = 0.3

  -- Set the color for the Button
  -- idle: Color for when the Button is not hovered over
  -- hover: Color for when the Button is hovered over
  setColor: (idle, hover) =>
    @idle_color = idle
    @hover_color = hover

  -- Set the Sprites for the button
  -- idle: Idle sprite of the Button
  -- hover: Sprite for when the Button is hovered over
  setSprite: (idle, hover) =>
    @idle_sprite = idle
    @hover_sprite = hover
    @sprited = true

  -- Checks if a Point is in the Button
  -- x: X coordinate of the Point
  -- y: Y coordinate of the Point
  isHovering: (x, y) =>
    xOn = @x <= x and @x + @width >= x
    yOn = @y <= y and @y + @height >= y
    return xOn and yOn

  -- Update state of the Button
  -- dt: Time since last update
  update: (dt) =>
    -- Check if the mouse is on the Button
    x, y = love.mouse.getPosition!
    @selected = @isHovering x, y

    -- Perform action if the mouse is clicked and the Button is selected
    if @selected and love.mouse.isDown 1
      -- Click the button if allowable
      if @clickable
        @action!
        @clickable = false
        @elapsed = 0

    -- Cooldown for reclick
    @elapsed += dt
    if @elapsed >= @max_time
      @clickable = true

    -- Update sprites if there are any
    if @sprited
      @idle_sprite\update dt
      @hover_sprite\update dt

  -- Draw the Button
  draw: =>
    -- Store transforms
    love.graphics.push "all"
    if @sprited
      -- Draw sprites
      if @selected
        @hover_sprite\draw @x + (@width / 2), @y + (@height / 2)
      else
        @idle_sprite\draw @x + (@width / 2), @y + (@height / 2)
    else
      -- Draw colored box
      if @selected
        love.graphics.setColor @hover_color[1], @hover_color[2], @hover_color[3], @hover_color[4]
      else
        love.graphics.setColor @idle_color[1], @idle_color[2], @idle_color[3], @idle_color[4]
      love.graphics.rectangle "fill", @x, @y, @width, @height

    -- Draw centered text
    love.graphics.setColor 0, 0, 0
    love.graphics.printf @text, @x, @y + ((@height - love.graphics.getFont!\getHeight!) / 2), @width, "center"

    -- Restore transforms
    love.graphics.pop!
