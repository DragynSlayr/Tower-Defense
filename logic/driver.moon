export class Driver
    new: =>
      @objects = {}
      love.keypressed = @keypressed
      love.keyreleased = @keyreleased
      love.mousepressed = @mousepressed
      love.mousereleased = @mousereleased
      love.focus = @focus
      love.load = @load
      love.update = @update
      love.draw = @draw

    addObject: (object, id) =>
      if @objects[id]
        @objects[id][#@objects[id] + 1] = object
        Renderer\add object, EntityTypes.layers[id]
      else
        @objects[id] = {}
        @addObject(object, id)

    keypressed: (key, scancode, isrepeat) ->
      if key == "escape"
        love.event.quit()
      elseif key == "p"
        export PAUSED = not PAUSED
      else
        for k, v in pairs Driver.objects[EntityTypes.player]
          v\keypressed key

    keyreleased: (key) ->
      for k, v in pairs Driver.objects[EntityTypes.player]
        v\keyreleased key
      return

    mouspressed: (x, y, button, isTouch) ->
      return

    mousereleased: (x, y, button, isTouch) ->
      return

    focus: (focus) ->
      return

    load: (arg) ->
      -- Create a player
      player = Player love.graphics.getWidth! / 2, love.graphics.getHeight! / 2, Sprite "test.tga", 16, 16, 0.29, 4
      player.sprite\setRotationSpeed -math.pi / 2
      Driver\addObject player, EntityTypes.player
      Objectives\nextMode!

    update: (dt) ->
      if PAUSED or GAME_OVER return
      for k, v in pairs Driver.objects
        for k2, o in pairs v
          o\update dt
          if o.health <= 0
            v[k2]\kill!
            Objectives\entityKilled v[k2]
            v[k2] = nil
      Objectives\update dt

    draw: ->
      love.graphics.push "all"
      Renderer\drawAlignedMessage SCORE .. "\t", 20, "right", Renderer.hud_font
      if not GAME_OVER
        Renderer\drawAll!
        Objectives\draw!
        if PAUSED
          Renderer\drawStatusMessage "PAUSED", love.graphics.getHeight! / 2, Renderer.giant_font
      else
        Renderer\drawStatusMessage "YOU DIED!", love.graphics.getHeight! / 2, Renderer.giant_font
      love.graphics.pop!
