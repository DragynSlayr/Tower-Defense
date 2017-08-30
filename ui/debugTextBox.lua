local moonscript = nil
local use_moon = false
if pcall(loadstring([[moonscript = require "moonscript.base"]])) then
  moonscript = require("moonscript.base")
  use_moon = true
end
do
  local _class_0
  local _parent_0 = TextBox
  local _base_0 = {
    recoverSaved = function(self)
      self.lines = self.saved[self.saved_index]
      if #self.lines > 0 then
        self.lines_index = #self.lines
      else
        self.lines_index = 1
      end
      if self.lines[self.lines_index] then
        self.char_index = #self.lines[self.lines_index]
      else
        self.char_index = 1
      end
    end,
    runText = function(self)
      self.saved[self.saved_index] = self.lines
      self.saved_index = self.saved_index + 1
      if self.saved_index > self.max_saved then
        self.saved_index = 1
      end
      local text = self:getText()
      self:resetText()
      if use_moon then
        pcall(moonscript.loadstring(text))
      else
        if pcall(loadstring(text)) then
          print("Success")
        else
          print("Failure")
        end
      end
      ScoreTracker.submitScore = function(self, text) end
      GameOver.ui_objects[2].active = false
      self.active = true
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, width, height)
      _class_0.__parent.__init(self, x, y, width, height)
      self.saved = {
        { },
        { },
        { },
        { },
        { },
        { },
        { },
        { },
        { },
        { }
      }
      self.max_saved = 10
      self.saved_index = 1
      self.action["pageup"] = function()
        self.saved_index = self.saved_index - 1
        if self.saved_index < 1 then
          self.saved_index = self.max_saved
        end
        return self:recoverSaved()
      end
      self.action["pagedown"] = function()
        self.saved_index = self.saved_index + 1
        if self.saved_index > self.max_saved then
          self.saved_index = 1
        end
        return self:recoverSaved()
      end
      self.action["return"] = function()
        if love.keyboard.isDown("rshift", "lshift") then
          return self:runText()
        else
          self.lines_index = self.lines_index + 1
          table.insert(self.lines, self.lines_index, { })
          self.char_index = 1
        end
      end
    end,
    __base = _base_0,
    __name = "DebugTextBox",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DebugTextBox = _class_0
end
