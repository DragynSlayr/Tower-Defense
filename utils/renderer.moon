-- Class for rendering GameObjects and text
export class Renderer
  new: =>
    -- Initialize queue and layers
    @queue = {}
    @layers = {}

    -- Load fonts
    @title_font = love.graphics.newFont "assets/fonts/opsb.ttf", 70
    @status_font = love.graphics.newFont "assets/fonts/opsb.ttf", 50
    @hud_font = love.graphics.newFont "assets/fonts/opsb.ttf", 30

    for i = 1, 10
      @layers[i] = {}

  -- Adds an object to the layers
  -- object: The object to add
  -- layer: The layer to add to
  add: (object, layer) =>
    if @layers[layer]
      -- Add object to layer
      @layers[layer][#@layers[layer] + 1] = object
    else
      -- Create layer if it does not exist
      @layers[layer] = {}
      @add(object, layer)

  -- Adds a drawing function to the queue
  -- func: The drawing function
  enqueue: (func) =>
    -- Add the function to the queue
    @queue[#@queue + 1] = func

  -- Draw everything in the layers
  drawAll: =>
    -- Store transforms
    love.graphics.push "all"

    -- Draw each GameObject in the layers
    for k, layer in pairs @layers
      for i, object in pairs layer
        object\draw!

    -- Call each function in the queue
    for k, func in pairs @queue
      func!

    -- Clear queue
    @queue = {}

    -- Restore transforms
    love.graphics.pop!

  -- Draws a HUD (large) message
  -- message: The message
  -- x: X location of the message
  -- y: Y location of the message
  -- font: The font to use
  drawHUDMessage: (message, x, y, font = @hud_font) =>
    -- Store transforms
    love.graphics.push "all"

    -- Apply new transforms
    love.graphics.setColor 0, 0, 0
    love.graphics.setFont font

    -- Display the message
    love.graphics.print message, x, y

    -- Restore transforms
    love.graphics.pop!

  -- Draws a status (centered) message
  -- message: The message
  -- y: Y location of the message
  -- font: The font to use
  drawStatusMessage: (message, y = 0, font = @status_font) =>
    -- Draw text in the center of the screen
    @drawAlignedMessage message, y, "center", font

  drawAlignedMessage: (message, y, alignment = "center", font = @status_font) =>
    -- Store transforms
    love.graphics.push "all"

    -- Apply new transforms
    love.graphics.setColor 0, 0, 0
    love.graphics.setFont font

    -- Draw an aligned message to the screen
    love.graphics.printf message, 0, y - (font\getHeight! / 2), love.graphics\getWidth!, alignment

    -- Restore transforms
    love.graphics.pop!
