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
      else
        for k, v in pairs Driver.objects[EntityTypes.player]
          v\keypressed key
          --Player\keypressed key

    keyreleased: (key) ->
      for k, v in pairs Driver.objects[EntityTypes.player]
        v\keyreleased key
      --Player\keyreleased key
      return

    mouspressed: (x, y, button, isTouch) ->
      return

    mousereleased: (x, y, button, isTouch) ->
      return

    focus: (focus) ->
      return

    load: (arg) ->
      --Renderer\add Player, 1
      return

    update: (dt) ->
      for k, v in pairs Driver.objects
        for k2, o in pairs v
          o\update dt
      --Player\update dt
      return

    draw: ->
      love.graphics.push "all"
      Renderer\drawAll!
      love.graphics.pop!
      return
