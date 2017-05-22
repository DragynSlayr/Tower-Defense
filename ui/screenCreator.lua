do
  local _class_0
  local _base_0 = {
    createMainMenu = function(self)
      UI:set_screen(Screen_State.main_menu)
      local title = Text(Screen_Size.width / 2, (Screen_Size.height / 4), "Tower Defense")
      UI:add(title)
      local start_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) - 32, 250, 60, "Start", function()
        Driver.game_state = Game_State.playing
        return UI:set_screen(Screen_State.none)
      end)
      UI:add(start_button)
      local exit_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) + 32, 250, 60, "Exit", function()
        return love.event.quit(0)
      end)
      return UI:add(exit_button)
    end,
    createPauseMenu = function(self)
      UI:set_screen(Screen_State.pause_menu)
      local title = Text(Screen_Size.width / 2, (Screen_Size.height / 3), "Game Paused")
      UI:add(title)
      local resume_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) - 32, 250, 60, "Resume", function()
        return Driver.unpause()
      end)
      return UI:add(resume_button)
    end,
    createGameOverMenu = function(self)
      UI:set_screen(Screen_State.game_over)
      local title = Text(Screen_Size.width / 2, (Screen_Size.height / 2), "YOU DIED!", Renderer.giant_font)
      UI:add(title)
      local restart_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) + 50, 250, 60, "Restart", function()
        return Driver.unpause()
      end)
      local quit_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) + 170, 250, 60, "Quit", function()
        return love.event.quit(0)
      end)
      return UI:add(quit_button)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self:createMainMenu()
      self:createPauseMenu()
      return self:createGameOverMenu()
    end,
    __base = _base_0,
    __name = "ScreenCreator"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ScreenCreator = _class_0
end
