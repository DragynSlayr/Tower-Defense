export class DebugTextBox extends TextBox
  new: (x, y, width, height) =>
    super x, y, width, height
    @status_text = ""

    @saved = {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}}
    @max_saved = 10
    @saved_index = 1

    @action["return"] = () ->
      if love.keyboard.isDown "rshift", "lshift"
        @lines_index += 1
        table.insert @lines, @lines_index, {}
        @char_index = 1
      else
        @saved[@saved_index] = @lines
        @saved_index += 1
        if  @saved_index > @max_saved
          @saved_index = 1
        text = @getText!
        @lines = {}
        @lines_index = 1
        @char_index = 1
        f = loadstring text
        if (pcall f)
          @status_text = "Command Successful"
        else
          @status_text = "Invalid Command"

    @action["pageup"] = () ->
      @saved_index -= 1
      if @saved_index < 1
        @saved_index = @max_saved
      @recoverSaved!

    @action["pagedown"] = () ->
      @saved_index += 1
      if @saved_index > @max_saved
        @saved_index = 1
      @recoverSaved!

  recoverSaved: =>
    @lines = @saved[@saved_index]
    if #@lines > 0
      @lines_index = #@lines
    else
      @lines_index = 1
    if @lines[@lines_index]
      @char_index = #@lines[@lines_index]
    else
      @char_index = 1

  draw: =>
    super!

    love.graphics.push "all"

    love.graphics.setColor 0, 255, 0, 255
    love.graphics.setFont @font
    height = @font\getHeight!
    width = @font\getWidth @status_text
    love.graphics.printf @status_text, @x + @width - (10 * Scale.width) - width, @y + @height - (10 * Scale.height) - height, width, "center"

    love.graphics.pop!
