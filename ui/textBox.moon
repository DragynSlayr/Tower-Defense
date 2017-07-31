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
    @cursor.position = Point 0, 0

    @active = true
    @selected = false

    @lines = {}
    @lines_index = 1
    @char_index = 1

    @action = {}
    @action["tab"] = () ->
      if not @lines[@lines_index]
        @lines[@lines_index] = {}
      for i = 1, 4
        table.insert @lines[@lines_index], @char_index, " "
        @char_index += 1

    @action["return"] = () ->
      @lines_index += 1
      table.insert @lines, @lines_index, {}
      @char_index = 1

    @action["up"] = () ->
      if @lines_index > 1
        @lines_index -= 1
        @char_index = #@lines[@lines_index]

    @action["down"] = () ->
      if @lines_index < #@lines
        @lines_index += 1
        @char_index = #@lines[@lines_index]

    @action["left"] = () ->
      if @char_index > 1
        @char_index -= 1

    @action["right"] = () ->
      if @lines[@lines_index]
        if @char_index < #@lines[@lines_index]
          @char_index += 1

  getText: =>
    s = ""
    for k, v in pairs @lines
      for k2, v2 in pairs v
        s ..= v2
      if k ~= #@lines
        s ..= "\n"
    return s

  getLine: (idx, idx2 = #@lines[idx]) =>
    s = ""
    for k, v in pairs @lines[idx]
      if k < idx2
        s ..= v
    return s

  textinput: (text) =>
    if @active
      if text ~= '`'
        if not @lines[@lines_index]
          @lines[@lines_index] = {}
        @char_index += 1
        table.insert @lines[@lines_index], @char_index, text

  keypressed: (key, scancode, isrepeat) =>
    if @active
      if key == "backspace"
        if #@lines[@lines_index] ~= 0
          table.remove @lines[@lines_index], @char_index
          @char_index -= 1
        else
          if @lines_index > 1
            @lines_index -= 1
            @char_index = #@lines[@lines_index]
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
    height = @font\getHeight!
    width = 0
    if @lines[@lines_index]
      width = @font\getWidth @getLine @lines_index, (@char_index + 1)
    @cursor.position = Point @x + (10 * Scale.width) + width, @y + (height / 2) + ((@lines_index - 1) * height)

  draw: =>
    love.graphics.push "all"

    love.graphics.setColor @color[1], @color[2], @color[3], @color[4]
    love.graphics.rectangle "fill", @x, @y, @width, @height

    text = @getText!

    love.graphics.setColor 0, 255, 0, 255
    love.graphics.setFont @font
    height = @font\getHeight!
    width = @font\getWidth text
    love.graphics.printf text, @x + (10 * Scale.width), @y + (height / 2), @width, "left"

    if @active
      love.graphics.setColor 0, 255, 0, @cursor.alpha
      width = 0
      if @lines[@lines_index]
        width = @font\getWidth @getLine @lines_index, (@char_index + 1)
      love.graphics.rectangle "fill", @x + (10 * Scale.width) + width, @y + (height / 2) + ((@lines_index - 1) * height), 10 * Scale.width, height
      @cursor.position = Point @x + (10 * Scale.width) + width, @y + (height / 2) + ((@lines_index - 1) * height)

    love.graphics.pop!
