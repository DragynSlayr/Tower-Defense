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
      local title = Text(Screen_Size.width / 2, (Screen_Size.height / 2), "YOU LOSE!", Renderer.giant_font)
      UI:add(title)
      local restart_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) + 50, 250, 60, "Restart", function()
        return Driver.unpause()
      end)
      local quit_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) + 170, 250, 60, "Quit", function()
        return love.event.quit(0)
      end)
      return UI:add(quit_button)
    end,
    createUpgradeMenu = function(self)
      UI:set_screen(Screen_State.upgrade)
      local bg = Background({
        255,
        255,
        255,
        255
      })
      UI:add(bg)
      local title = Text(Screen_Size.width / 2, 25, "Upgrade")
      UI:add(title)
      UI:add(Text(100, 100, "Player", Renderer.hud_font))
      local stats = {
        "Health",
        "Range",
        "Damage",
        "Speed",
        "Special"
      }
      for k, v in pairs(stats) do
        local y = 100 + (k * 65)
        UI:add(Text(200, y, v, Renderer.small_font))
        if k ~= 5 then
          local tt = Tooltip(400, y - 30, "Increase  Player  " .. v .. "  by  " .. Upgrade.amount[1][k], Renderer:newFont(15))
          local tt2 = Tooltip(Screen_Size.width * 0.9, y, "(+" .. math.abs(Upgrade.amount[1][k]) .. ")", Renderer:newFont(30))
          tt2.color = {
            0,
            225,
            0,
            255
          }
          local b = TooltipButton(280, y, 30, 30, "+", (function()
            return Upgrade:add_skill(Upgrade_Trees.player_stats, k)
          end), nil, {
            tt,
            tt2
          })
          UI:add(b)
          UI:add(tt)
          UI:add(tt2)
        else
          local specials = {
            "1",
            "2",
            "3",
            "4"
          }
          for k, v in pairs(specials) do
            local x = 280 + ((k - 1) * 100)
            local b = Button(x, y, 50, 30, v, function()
              return Upgrade:add_skill(Upgrade_Trees.player_special, k)
            end)
            UI:add(b)
          end
        end
      end
      UI:add(Text(100, 500, "Turret", Renderer.hud_font))
      stats = {
        "Health",
        "Range",
        "Damage",
        "Cooldown",
        "Special"
      }
      for k, v in pairs(stats) do
        local y = 500 + (k * 65)
        UI:add(Text(200, y, v, Renderer.small_font))
        if k ~= 5 then
          local tt = Tooltip(400, y - 30, "Increase  Turret  " .. v .. "  by  " .. Upgrade.amount[2][k], Renderer:newFont(15))
          local tt2 = Tooltip(Screen_Size.width * 0.9, y, "(+" .. math.abs(Upgrade.amount[2][k]) .. ")", Renderer:newFont(30))
          tt2.color = {
            0,
            225,
            0,
            255
          }
          local b = TooltipButton(280, y, 30, 30, "+", (function()
            return Upgrade:add_skill(Upgrade_Trees.turret_stats, k)
          end), nil, {
            tt,
            tt2
          })
          UI:add(b)
          UI:add(tt)
          UI:add(tt2)
        else
          local specials = {
            "1",
            "2",
            "3",
            "4"
          }
          for k, v in pairs(specials) do
            local x = 280 + ((k - 1) * 100)
            local b = Button(x, y, 50, 30, v, function()
              return Upgrade:add_skill(Upgrade_Trees.turret_special, k)
            end)
            UI:add(b)
          end
        end
      end
      local continue_button = Button(Screen_Size.width / 2, Screen_Size.height - 35, 200, 50, "Continue", function()
        UI:set_screen(Screen_State.none)
        Driver.game_state = Game_State.playing
        Driver:respawnPlayers()
        return Objectives:nextMode()
      end)
      return UI:add(continue_button)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self:createMainMenu()
      self:createPauseMenu()
      self:createGameOverMenu()
      return self:createUpgradeMenu()
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
