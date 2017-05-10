export class Objectives
  new: =>
    @num_modes = 1
    @mode = nil
    @elapsed = 0
    @delay = 10
    @modes = {EliminationMode!}
    @counter = 0

  nextMode: =>
    @counter += 1
    if @counter <= #@modes
      @mode = @modes[@counter]
      @mode\start!
    else
      @counter = 0
      MathHelper\shuffle @modes
      -- Boss Wave
      @nextMode!

  entityKilled: (entity) =>
    @mode\entityKilled entity

  update: (dt) =>
    if not @mode.complete
      @mode\update dt
    else
      @elapsed += dt
      if @elapsed >= @delay
        @elapsed = 0
        @nextMode!

  draw: =>
    if not @mode.complete
      @mode\draw!
    else
      love.graphics.push "all"
      Renderer\drawStatusMessage "Objective Complete!", love.graphics.getHeight! / 2, Renderer.title_font
      love.graphics.pop!
