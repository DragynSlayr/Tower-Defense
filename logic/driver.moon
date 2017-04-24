export class Driver
    new: =>
      love.keypressed = @keypressed
      love.keyreleased = @keyreleased
      love.mousepressed = @mousepressed
      love.mousereleased = @mousereleased
      love.focus = @focus
      love.load = @load
      love.update = @update
      love.draw = @draw

    keypressed: (key, scancode, isrepeat) ->
      if key == "escape"
        love.event.quit()
      else
        Player\keypressed key

    keyreleased: (key) ->
      Player\keyreleased key
      return

    mouspressed: (x, y, button, isTouch) ->
      return

    mousereleased: (x, y, button, isTouch) ->
      return

    focus: (focus) ->
      return

    load: (arg) ->
      Renderer\add Player, 1
      return

    update: (dt) ->
      Player\update dt
      return

    draw: ->
      love.graphics.push "all"
      Renderer\drawAll!
      love.graphics.pop!
      return
