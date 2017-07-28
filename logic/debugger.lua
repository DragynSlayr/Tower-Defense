do
  local _class_0
  local _base_0 = {
    createMenu = function(self)
      local bg = Background({
        0,
        0,
        0,
        127
      })
      self:add(bg)
      local x = Screen_Size.width - (135 * Scale.width)
      local y = Screen_Size.height - (40 * Scale.height)
      local back_button = Button(x, y, 250, 60, "Back", function()
        DEBUG_MENU = false
      end)
      self:add(back_button)
      local width = Screen_Size.width - (20 * Scale.width)
      local height = Screen_Size.height - (95 * Scale.height)
      local text_box = DebugTextBox(10 * Scale.width, 10 * Scale.height, width, height)
      return self:add(text_box)
    end,
    add = function(self, object)
      return table.insert(self.ui_objects, object)
    end,
    keypressed = function(self, key, scancode, isrepeat)
      for k, v in pairs(self.ui_objects) do
        v:keypressed(key, scancode, isrepeat)
      end
    end,
    keyreleased = function(self, key)
      for k, v in pairs(self.ui_objects) do
        v:keyreleased(key)
      end
    end,
    mousepressed = function(self, x, y, button, isTouch)
      for k, v in pairs(self.ui_objects) do
        v:mousepressed(x, y, button, isTouch)
      end
    end,
    mousereleased = function(self, x, y, button, isTouch)
      for k, v in pairs(self.ui_objects) do
        v:mousereleased(x, y, button, isTouch)
      end
    end,
    textinput = function(self, text)
      for k, v in pairs(self.ui_objects) do
        v:textinput(text)
      end
    end,
    update = function(self, dt)
      for k, v in pairs(self.ui_objects) do
        v:update(dt)
      end
    end,
    draw = function(self)
      for k, v in pairs(self.ui_objects) do
        v:draw()
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      DEBUG_MENU_ENABLED = true
      DEBUG_MENU = false
      DEBUGGING = false
      SHOW_RANGE = false
      self.ui_objects = { }
      return self:createMenu()
    end,
    __base = _base_0,
    __name = "DebugMenu"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DebugMenu = _class_0
end
