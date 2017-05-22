export class Mode
  new: (parent) =>
    @parent = parent
    @level_count = 1
    @wave_count = 1
    @complete = false
    @wave = nil
    @message1 = ""
    @message2 = ""
    @objective_text = ""
    @started = false

  entityKilled: (entity) =>
    @wave\entityKilled entity

  nextWave: =>
    @parent.difficulty += 1

  start: =>
    @complete = false
    @wave_count = 1
    @nextWave!
    @started = true

  update: (dt) =>
    if not @complete
      if not @started
        @start!
      if not @wave.complete
        @wave\update dt
        level = @parent\getLevel! + 1
        @message2 = "Level " .. level .. "\tWave " .. @wave_count .. "/3"
      else
        @wave_count += 1
        if (@wave_count - 1) % 3 == 0
          @level_count += 1
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
    Renderer\drawAlignedMessage @objective_text, 50, "center", Renderer.hud_font
    love.graphics.pop!
