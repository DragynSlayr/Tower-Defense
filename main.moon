--require("logic.classLoader")

--+---------------------------------------+
--| Remaps functions and sets up the game |
--+---------------------------------------+
init = ->
  -- Register key events
  --love.keypressed = Driver.keyPressed
  --love.keyreleased = Driver.keyReleased

  -- Register mouse events
  --love.mousepressed = Driver.mousePressed

  -- Register window events
  --love.focus = Driver.focus

  -- Register love events
  --love.load = Driver.load
  --love.update = Driver.update
  --love.draw = Driver.draw

  -- Set love environment
  love.graphics.setBackgroundColor(200, 200, 200)
  love.graphics.setDefaultFilter("nearest", "nearest")

init!
