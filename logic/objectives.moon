export class Objectives
  new: =>
    @num_modes = 1
    @mode = nil
    @elapsed = 0
    @delay = 10

  nextMode: =>
    num = math.random @num_modes
    @mode = switch num
      when 1
        EliminationMode 15
      else
        nil

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
      Renderer\drawStatusMessage "Objective Complete!", love.graphics.getHeight! / 2
      love.graphics.pop!
