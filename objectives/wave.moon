export class Wave
  new: (parent) =>
    @elapsed = 0
    @delay = 5
    @waiting = true
    @complete = false
    @parent = parent

  start: =>
    return

  finish: =>
    if Driver.objects[EntityTypes.bullet]
      for k, b in pairs Driver.objects[EntityTypes.bullet]
        Driver\removeObject b, false
    if Driver.objects[EntityTypes.bomb]
      for k, b in pairs Driver.objects[EntityTypes.bomb]
        Driver\removeObject b, false

  entityKilled: (entity) =>
    return

  update: (dt) =>
    if @waiting
      @elapsed += dt
      if @elapsed >= @delay
        @elapsed = 0
        @waiting = false
        @start!

  draw: =>
    if @waiting
      love.graphics.push "all"
      message = (@delay - math.floor @elapsed)
      Renderer\drawStatusMessage message, love.graphics.getHeight! / 2, Renderer.giant_font, Color 255, 255, 255, 255
      Renderer\drawAlignedMessage "Next wave in: " .. message .. "\t", 50 * Scale.height, "right", Renderer.hud_font
      love.graphics.pop!
