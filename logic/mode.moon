export class Mode
  new: =>
    @elapsed = 0
    @delay = 5
    @waiting = true
    @complete = false
    @message = "DEFAULT MODE"

  start: =>
    return

  entityKilled: (entity) =>
    return

  update: (dt) =>
    if @waiting
      @elapsed += dt
      if @elapsed >= @delay
        @waiting = false
        @start!

  draw: =>
    love.graphics.push "all"
    love.graphics.setColor 0, 0, 0, 255
    Renderer\drawAlignedMessage @message, 20, "left", Renderer.hud_font
    love.graphics.pop!
