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
    @mode_type = ""

  entityKilled: (entity) =>
    @wave\entityKilled entity

  nextWave: =>
    @parent.difficulty += 1

  start: =>
    @complete = false
    @wave_count = 1
    @nextWave!
    @started = true

  finish: =>
    Driver\clearObjects EntityTypes.turret
    Driver\clearObjects EntityTypes.bullet
    Driver\clearObjects EntityTypes.background
    Driver\clearObjects EntityTypes.goal
    hit = false
    if Driver.objects[EntityTypes.player]
      for k, p in pairs Driver.objects[EntityTypes.player]
        p.num_turrets = 0
        p.can_place = true
        p.health = p.max_health
        p.attack_range = Stats.player[2]
        if p.hit
          hit = true
    if not hit
      Upgrade\add_point 3
    else
      Upgrade\add_point 2
    @parent.shader = nil

  update: (dt) =>
    if not @complete
      if not @started
        @start!
      if not @wave.complete
        @wave\update dt
        level = @parent\getLevel! + 1
        @message2 = "Level " .. level .. "\tWave " .. @wave_count .. "/3"
        if @wave.complete
          @wave\finish!
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
    Renderer\drawAlignedMessage @message1, 20 * Scale.height, "left", Renderer.hud_font
    Renderer\drawAlignedMessage @message2, 20 * Scale.height, "center", Renderer.hud_font
    Renderer\drawAlignedMessage @objective_text, 50 * Scale.height, "center", Renderer.hud_font
    love.graphics.pop!
