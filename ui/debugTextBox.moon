moonscript = nil
use_moon = false
if pcall loadstring [[moonscript = require "moonscript.base"]]
  moonscript = require "moonscript.base"
  use_moon = true

export class DebugTextBox extends TextBox
  new: (x, y, width, height) =>
    super x, y, width, height

    @saved = {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}}
    @max_saved = 10
    @saved_index = 1

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

  runText: =>
    @saved[@saved_index] = @lines
    @saved_index += 1
    if  @saved_index > @max_saved
      @saved_index = 1
    text = @getText!
    @resetText!
    if use_moon
      pcall moonscript.loadstring text
    else
      if pcall loadstring text
        print "Success"
      else
        print "Failure"
    @active = true
