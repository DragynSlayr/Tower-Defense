export class AutoComplete
  new: =>
    @resetText!

    @trie = Trie!
    @font = love.graphics.newFont 20

    if DEBUG_MENU_ENABLED
      @addWords!

    @text_box = nil

  addWords: =>
    temp = getAllDirectories ""
    dirs = {}
    for k, v in pairs temp
      splitted = split v, "/"
      if splitted[2] ~= "assets" and splitted[2] ~= ".git"
        table.insert dirs, splitted[2]
    to_read = {}
    for k, v in pairs dirs
      files = getAllFiles v
      for k, v in pairs files
        splitted = split v, "."
        if splitted[2] == "moon"
          table.insert to_read, v
    for k, v in pairs to_read
      contents, size = love.filesystem.read v
      splitted = split contents, "\n"
      for k2, v2 in pairs splitted
        words = split v2, " "
        found = false
        var = ""
        for k3, v3 in pairs words
          if v3 == "export"
            found = true
            var = words[k3 + 1]
            if var == "class"
              var = words[k3 + 2]
            break
        if found
          @trie\add removeChars var, {",", ".", "/", "+", "-", "*", "(", ")", "?", "<", ">", ":", ";", "~", "=", "%", "\t", "\n", "\r"}

  resetText: =>
    @text = ""
    @last_text = " "
    @words = {}

  keypressed: (key, scancode, isrepeat) =>
    if key == "return"
      @resetText!
    elseif key == "backspace"
      @text = string.sub @text, 1, #@text - 1

  textinput: (text) =>
    if text == "." or text == " "
      @resetText!
    else
      if text ~= '`'
        @text ..= text

  update: (dt) =>
    if @last_text ~= @text
      @last_text = @text
      @words = @trie\getWords @text

  draw: =>
    love.graphics.push "all"

    love.graphics.setColor 0, 255, 255, 255
    love.graphics.setFont @font

    height = @font\getHeight!
    x = @text_box.cursor.position.x--Screen_Size.width * 0.8
    y = @text_box.cursor.position.y + height + (5 * Scale.height)--(10 * Scale.height) + (height / 2)

    for k, word in pairs @words
      if y + (height * 1.25) < (@text_box.x + @text_box.height)
        love.graphics.printf word, x, y, @font\getWidth word, "right"
        y += height * 1.25
      else
        break

    love.graphics.pop!
