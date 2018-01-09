do
  local _base_0 = {
    add = function(self, element, screen)
      if screen == nil then
        screen = self.current_screen
      end
      self.screens[screen][#self.screens[screen] + 1] = element
    end,
    set_screen = function(self, new_screen)
      self.current_screen = new_screen
    end,
    filter = function(self, typeof, layer)
      if layer == nil then
        layer = self.current_screen
      end
      local elements = { }
      for k, v in pairs(self.screens[layer]) do
        if v.__class == typeof.__class then
          table.insert(elements, v)
        end
      end
      return elements
    end,
    keypressed = function(self, key, scancode, isrepeat)
      for k, v in pairs(self.screens[self.current_screen]) do
        v:keypressed(key, scancode, isrepeat)
      end
    end,
    keyreleased = function(self, key)
      for k, v in pairs(self.screens[self.current_screen]) do
        v:keyreleased(key)
      end
    end,
    mousepressed = function(self, x, y, button, isTouch)
      for k, v in pairs(self.screens[self.current_screen]) do
        v:mousepressed(x, y, button, isTouch)
      end
    end,
    mousereleased = function(self, x, y, button, isTouch)
      for k, v in pairs(self.screens[self.current_screen]) do
        v:mousereleased(x, y, button, isTouch)
      end
    end,
    textinput = function(self, text)
      for k, v in pairs(self.screens[self.current_screen]) do
        v:textinput(text)
      end
    end,
    focus = function(self, focus)
      for k, v in pairs(self.screens[self.current_screen]) do
        v:focus(focus)
      end
    end,
    update = function(self, dt)
      for k, v in pairs(self.screens[self.current_screen]) do
        v:update(dt)
      end
    end,
    draw = function(self, included)
      if included == nil then
        included = { }
      end
      for k, v in pairs(self.screens[self.current_screen]) do
        if #included == 0 or (tableContains(included, v.__class)) then
          v:draw()
        end
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self.screens = { }
      self.current_screen = Screen_State.none
      self.state_stack = Stack()
      self.state_stack:add(Screen_State.main_menu)
      for k, v in pairs(Screen_State) do
        self.screens[v] = { }
      end
    end,
    __base = _base_0,
    __name = "UIHandler"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  UIHandler = _class_0
end
