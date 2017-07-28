export class DebugTextBox extends TextBox
  new: (x, y, width, height) =>
    super x, y, width, height
    @status_text = ""

    @saved = {"", "", "", "", "", "", "", "", "", ""}
    @max_saved = 10
    @saved_index = 1

    @action["return"] = () ->
      if love.keyboard.isDown "rshift", "lshift"
        @text ..= "\n"
      else
        @saved[@saved_index] = @text
        @saved_index += 1
        if @saved_index > @max_saved
          @saved_index = 1
        text = @text
        @text = ""
        f = loadstring text
        if (pcall f)
          @status_text = "Command Successful"
        else
          @status_text = "Invalid Command"

    @action["up"] = () ->
      @saved_index -= 1
      if @saved_index < 1
        @saved_index = @max_saved
      @text = @saved[@saved_index]

    @action["down"] = () ->
      @saved_index += 1
      if @saved_index > @max_saved
        @saved_index = 1
      @text = @saved[@saved_index]

  draw: =>
    super!

    love.graphics.push "all"

    love.graphics.setColor 0, 255, 0, 255
    love.graphics.setFont @font
    height = @font\getHeight!
    width = @font\getWidth @status_text
    love.graphics.printf @status_text, @x + @width - (10 * Scale.width) - width, @y + @height - (10 * Scale.height) - height, width, "center"

    love.graphics.pop!
