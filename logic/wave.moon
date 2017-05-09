export class Wave
  new: (parent) =>
    @elapsed = 0
    @delay = 5
    @waiting = true
    @complete = false
    @parent = parent

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
    if @waiting
      love.graphics.push "all"
      message = (@delay - math.floor @elapsed)
      Renderer\drawStatusMessage message, love.graphics.getHeight! / 2, Renderer.giant_font
      love.graphics.pop!
