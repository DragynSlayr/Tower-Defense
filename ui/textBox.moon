export class TextBox extends UIElement
  new: (x, y, width, height) =>
    super x, y
    @width = width
    @height = height
    @color = {0, 0, 0, 127}
    @font = love.graphics.newFont 20
    @elapsed = 0

    @cursor = {}
    @cursor.alpha = 255
    @cursor.on_time = 0.33
    @cursor.off_time = 0.33
    @cursor.is_on = true

    @action = {}
    @action["tab"] = () ->
      @text ..= "    "

    @active = false
    @selected = false

  textinput: (text) =>
    if @active
      if text ~= '`'
        @text ..= text

  keypressed: (key, scancode, isrepeat) =>
    if @active
      if key == "backspace"
        length = string.len @text
        if length > 0
          @text = string.sub @text, 1, length - 1
        else
          @text = ""
      else
        if @action[key]
          @action[key]!

  isHovering: (x, y) =>
    xOn = @x <= x and @x + @width >= x
    yOn = @y <= y and @y + @height >= y
    return xOn and yOn

  mousepressed: (x, y, button, isTouch) =>
    if button == 1
      @selected = @isHovering x, y

  mousereleased: (x, y, button, isTouch) =>
    if button == 1
      selected = @isHovering x, y
      if selected and @selected
        @active = true
      else
        @active = false
      @selected = false

  update: (dt) =>
    @elapsed += dt
    if @cursor.is_on
      if @elapsed >= @cursor.on_time
        @elapsed = 0
        @cursor.alpha = 0
        @cursor.is_on = false
    else
      if @elapsed >= @cursor.off_time
        @elapsed = 0
        @cursor.alpha = 255
        @cursor.is_on = true

  draw: =>
    love.graphics.push "all"

    love.graphics.setColor @color[1], @color[2], @color[3], @color[4]
    love.graphics.rectangle "fill", @x, @y, @width, @height

    love.graphics.setColor 0, 255, 0, 255
    love.graphics.setFont @font
    height = @font\getHeight!
    width = @font\getWidth @text
    love.graphics.printf @text, @x + (10 * Scale.width), @y + (height / 2), @width, "left"

    if @active
      love.graphics.setColor 0, 255, 0, @cursor.alpha
      num_lines = 0
      last_n = 1
      for i = 1, #@text
        if (string.sub @text, i, i) == "\n"
          num_lines += 1
          last_n = i
      width = @font\getWidth string.sub @text, last_n, #@text
      love.graphics.rectangle "fill", @x + (10 * Scale.width) + width, @y + (height / 2) + (num_lines * height), 10 * Scale.width, height

    love.graphics.pop!
