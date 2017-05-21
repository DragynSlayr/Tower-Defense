export class Driver
    new: =>
      @objects = {}
      @game_state = Game_State.none
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

    removeObject: (object, player_kill = true) =>
      for k, v in pairs Driver.objects
        for k2, o in pairs v
          if object == o
            Renderer\removeObject object
            if player_kill
              v[k2]\kill!
              Objectives\entityKilled v[k2]
            v[k2] = nil
            break

    killEnemies: =>
      if Driver.objects[EntityTypes.enemy]
        for k, o in pairs Driver.objects[EntityTypes.enemy]
          @removeObject o, false

    isClear: =>
      sum = 0
      for k, v in pairs Driver.objects
        for k2, o in pairs v
          if k ~= EntityTypes.player and k ~= EntityTypes.turret
            sum += 1
      return sum == 0

    keypressed: (key, scancode, isrepeat) ->
      if key == "escape"
        love.event.quit()
      elseif key == "p"
        export PAUSED = not PAUSED
--      elseif key == "n"
--        Objectives.difficulty += 1
--        Objectives.mode\nextWave!
      else
        if not (PAUSED or GAME_OVER)
          for k, v in pairs Driver.objects[EntityTypes.player]
            v\keypressed key

    keyreleased: (key) ->
      if not (PAUSED or GAME_OVER)
        for k, v in pairs Driver.objects[EntityTypes.player]
          v\keyreleased key

    mousepressed: (x, y, button, isTouch) ->
      UI\mousepressed x, y, button, isTouch

    mousereleased: (x, y, button, isTouch) ->
      UI\mousereleased x, y, button, isTouch

    focus: (focus) ->
      UI\focus focus

    load: (arg) ->
      --b = Button Screen_Size.width / 2, Screen_Size.height / 2, 100, 50, "Start", () -> Driver.game_state = Game_State.playing
      --UI\add b
      --t = Text Screen_Size.width / 2, (Screen_Size.height / 2) - 75, "Tower Defense"
      --UI\add t
      
      -- Create a player
      player = Player love.graphics.getWidth! / 2, love.graphics.getHeight! / 2, Sprite "test.tga", 16, 16, 0.29, 4
      player.sprite\setRotationSpeed -math.pi / 2
      Driver\addObject player, EntityTypes.player
      Objectives\nextMode!

    update: (dt) ->
      if GAME_OVER
        Driver.objects = nil
        Renderer.layers = nil
      if PAUSED or GAME_OVER return
      for k, v in pairs Driver.objects
        for k2, o in pairs v
          o\update dt
          if o.health <= 0 or not o.alive
            Driver\removeObject o
      Objectives\update dt
      UI\update dt

    draw: ->
      love.graphics.push "all"
      UI\draw!
      Renderer\drawAlignedMessage SCORE .. "\t", 20, "right", Renderer.hud_font
      if not GAME_OVER
        Renderer\drawAll!
        Objectives\draw!
        if PAUSED
          Renderer\drawStatusMessage "PAUSED", love.graphics.getHeight! / 2, Renderer.giant_font
      else
        Renderer\drawStatusMessage "YOU DIED!", love.graphics.getHeight! / 2, Renderer.giant_font
      love.graphics.pop!

      before = math.floor collectgarbage "count"
      collectgarbage "step"
      after = math.floor collectgarbage "count"
      --print "B: " .. before .. "; A: " .. after .. "; R: " .. (before - after)
