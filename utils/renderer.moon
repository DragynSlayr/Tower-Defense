export class Renderer
  new: =>
    @queue = {}
    @layers = {}
    @title_font = love.graphics.newFont "assets/fonts/opsb.ttf", 70
    @status_font = love.graphics.newFont "assets/fonts/opsb.ttf", 50
    @hud_font = love.graphics.newFont "assets/fonts/opsb.ttf", 30

  add: (object, layer) =>
    if @layers[layer]
      @layers[layer][#@layers[layer] + 1] = object
    else
      @layers[layer] = {}
      @add(object, layer)

  enqueue: (func) =>
    @queue[#@queue + 1] = func

  drawAll: =>
    love.graphics.push "all"
    for k, layer in pairs @layers
      for i, object in pairs layer
        object\draw!
    for k, func in pairs @queue
      func!
    @queue = {}
    love.graphics.pop!

  drawHUDMessage: (message, x, y, font = @hud_font) =>
    love.graphics.push "all"
    love.graphics.setColor 0, 0, 0
    love.graphics.setFont font
    love.graphics.print message, x, y
    love.graphics.pop!

  drawStatusMessage: (message, y = 0, font = @status_font) =>
    love.graphics.push "all"
    love.graphics.setColor 0, 0, 0
    love.graphics.setFont font
    love.graphics.printf message, 0, y, love.graphics\getWidth!, "center"
    love.graphics.pop!

  drawAlignedMessage: (message, y, alignment = "center", font = @status_font) =>
    love.graphics.push "all"
    love.graphics.setColor 0, 0, 0
    love.graphics.setFont font
    love.graphics.printf message, 0, y - (font\getHeight! / 2), love.graphics\getWidth!, alignment
    love.graphics.pop!
