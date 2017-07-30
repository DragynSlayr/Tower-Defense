do
  local _class_0
  local _base_0 = {
    addWords = function(self)
      local temp = getAllDirectories("")
      local dirs = { }
      for k, v in pairs(temp) do
        local splitted = split(v, "/")
        if splitted[2] ~= "assets" and splitted[2] ~= ".git" then
          table.insert(dirs, splitted[2])
        end
      end
      local to_read = { }
      for k, v in pairs(dirs) do
        local files = getAllFiles(v)
        for k, v in pairs(files) do
          local splitted = split(v, ".")
          if splitted[2] == "moon" then
            table.insert(to_read, v)
          end
        end
      end
      for k, v in pairs(to_read) do
        local contents, size = love.filesystem.read(v)
        local splitted = split(contents, "\n")
        for k2, v2 in pairs(splitted) do
          local words = split(v2, " ")
          local found = false
          local var = ""
          for k3, v3 in pairs(words) do
            if v3 == "export" then
              found = true
              var = words[k3 + 1]
              if var == "class" then
                var = words[k3 + 2]
              end
              break
            end
          end
          if found then
            self.trie:add(removeChars(var, {
              ",",
              ".",
              "/",
              "+",
              "-",
              "*",
              "(",
              ")",
              "?",
              "<",
              ">",
              ":",
              ";",
              "~",
              "=",
              "%",
              "\t",
              "\n",
              "\r"
            }))
          end
        end
      end
    end,
    resetText = function(self)
      self.text = ""
      self.last_text = " "
      self.words = { }
    end,
    keypressed = function(self, key, scancode, isrepeat)
      if key == "return" then
        return self:resetText()
      elseif key == "backspace" then
        self.text = string.sub(self.text, 1, #self.text - 1)
      end
    end,
    textinput = function(self, text)
      if text == "." or text == " " then
        return self:resetText()
      else
        if text ~= '`' then
          self.text = self.text .. text
        end
      end
    end,
    update = function(self, dt)
      if self.last_text ~= self.text then
        self.last_text = self.text
        self.words = self.trie:getWords(self.text)
      end
    end,
    draw = function(self)
      love.graphics.push("all")
      love.graphics.setColor(0, 255, 255, 255)
      love.graphics.setFont(self.font)
      local height = self.font:getHeight()
      local x = self.text_box.cursor.position.x
      local y = self.text_box.cursor.position.y + height + (5 * Scale.height)
      for k, word in pairs(self.words) do
        if y + (height * 1.25) < (self.text_box.x + self.text_box.height) then
          love.graphics.printf(word, x, y, self.font:getWidth(word, "right"))
          y = y + (height * 1.25)
        else
          break
        end
      end
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self:resetText()
      self.trie = Trie()
      self.font = love.graphics.newFont(20)
      if DEBUG_MENU_ENABLED then
        self:addWords()
      end
      self.text_box = nil
    end,
    __base = _base_0,
    __name = "AutoComplete"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  AutoComplete = _class_0
end
