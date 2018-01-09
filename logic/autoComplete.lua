do
  local _base_0 = {
    addWords = function(self)
      local contents, size = love.filesystem.read("words.txt")
      local splitted = split(contents, "\n")
      for k, v in pairs(splitted) do
        self.trie:add(removeChars(v, {
          "\r",
          "\n",
          "\t",
          " "
        }))
      end
    end,
    resetText = function(self)
      self.text = ""
      self.last_text = ""
      self.words = { }
    end,
    keypressed = function(self, key, scancode, isrepeat)
      if self.text_box.active then
        if key == "return" then
          return self:resetText()
        elseif key == "tab" then
          if #self.text > 0 and #self.words > 0 then
            self.text_box:addText(self.words[1], self.text)
          end
          return self:resetText()
        elseif key == "backspace" then
          self.text = string.sub(self.text, 1, #self.text - 1)
          if #self.text == 0 then
            return self:resetText()
          end
        end
      end
    end,
    textinput = function(self, text)
      if self.text_box.active then
        if tableContains(self.reset_chars, text) then
          return self:resetText()
        else
          if text ~= '`' then
            self.text = self.text .. text
          end
        end
      end
    end,
    update = function(self, dt)
      self.max_words = self.text_box.height - (self.text_box.cursor.position.y + self.font:getHeight() + (5 * Scale.height))
      self.max_words = self.max_words / (self.font:getHeight() * 1.25)
      self.max_words = math.ceil(self.max_words)
      if self.last_text ~= self.text then
        self.last_text = self.text
        self.words = self.trie:getWords(self.text)
        table.sort(self.words)
        if #self.words > self.max_words then
          local words = { }
          for i = 1, self.max_words do
            table.insert(words, self.words[i])
          end
          self.words = words
        end
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
          love.graphics.printf(word, x, y, self.font:getWidth(word, "center"))
          y = y + (height * 1.25)
        else
          break
        end
      end
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self:resetText()
      self.trie = Trie()
      self.font = love.graphics.newFont(20)
      if DEBUG_MENU_ENABLED then
        self:addWords()
      end
      self.text_box = nil
      self.reset_chars = {
        ".",
        " ",
        "\\",
        "(",
        ")",
        "{",
        "}",
        "[",
        "]"
      }
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
