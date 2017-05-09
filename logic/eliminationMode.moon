export class EliminationMode
  new: =>
    @level = 1
    @counter = 1
    @complete = false
    @wave = nil
    @message1 = ""
    @message2 = ""
    @started = false

  entityKilled: (entity) =>
    @wave\entityKilled entity


  nextWave: =>
    num = (((@counter - 1) * 3) + @level) * 3
    @wave = EliminationWave @, num + 5

  start: =>
    @complete = false
    @level = 1
    @nextWave!
    @started = true

  update: (dt) =>
    if not @complete
      if not @started
        @start!
      if not @wave.complete
        @wave\update dt
        @message2 = "Level " .. @counter .. "\tWave " .. @level .. "/3"
      else
        @level += 1
        if (@level - 1) % 3 == 0
          @counter += 1
          @complete = true
          @started = false
        else
          @nextWave!

  draw: =>
    @wave\draw!
    love.graphics.push "all"
    love.graphics.setColor 0, 0, 0, 255
    Renderer\drawAlignedMessage @message1, 20, "left", Renderer.hud_font
    Renderer\drawAlignedMessage @message2, 20, "center", Renderer.hud_font
    love.graphics.pop!
