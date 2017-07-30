moonscript = require "moonscript.base"

export class DebugTextBox extends TextBox
  new: (x, y, width, height) =>
    super x, y, width, height

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
        @lines = {{}}
        @lines_index = 1
        @char_index = 1
        pcall moonscript.loadstring text

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
