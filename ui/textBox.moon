export class TextBox extends UIElement
  new: (x, y, width, height) =>
    super x, y
    @width = width
    @height = height
    @color = {127, 127, 127, 200}
    @font = love.graphics.newFont 20
    @action = {}

  textinput: (text) =>
    if text ~= '`'
      @text ..= text

  keypressed: (key, scancode, isrepeat) =>
    if key == "backspace"
      length = string.len @text
      if length > 0
        @text = string.sub @text, 1, length - 1
      else
        @text = ""
    else
      if @action[key]
        @action[key]!

  draw: =>
    love.graphics.push "all"
    love.graphics.setColor @color[1], @color[2], @color[3], @color[4]
    love.graphics.rectangle "fill", @x, @y, @width, @height
    love.graphics.setColor 0, 0, 0, 255
    love.graphics.setFont @font
    height = @font\getHeight!
    width = @font\getWidth @text
    love.graphics.printf @text, @x + (10 * Scale.width), @y + (height / 2), @width, "left"
    love.graphics.pop!
