export class UIElement
  new: (x, y, text, font = Renderer.status_font) =>
    @x = x
    @y = y
    @text = text
    @font = font

  keypressed: (key, scancode, isrepeat) =>
    return

  keyreleased: (key) =>
    return

  mousepressed: (x, y, button, isTouch) =>
    return

  mousereleased: (x, y, button, isTouch) =>
    return

  focus: (focus) =>
    return

  update: (dt) =>
    return

  draw: =>
    love.graphics.push "all"
    love.graphics.setColor 0, 0, 0, 255
    love.graphics.setFont @font
    height = @font\getHeight!
    width = @font\getWidth @text
    love.graphics.printf @text, @x - (width / 2), @y - (height / 2), width, "center"
    love.graphics.pop!
