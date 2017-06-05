do
  local _class_0
  local _base_0 = {
    createHelp = function(self)
      local keys = { }
      keys["space"] = Sprite("keys/space.tga", 32, 64, 1, 1)
      for k, v in pairs({
        "w",
        "a",
        "s",
        "d",
        "p",
        "e",
        "z"
      }) do
        keys[v] = Sprite("keys/" .. v .. ".tga", 32, 32, 1, 1)
      end
      local font = Renderer:newFont(20)
      local start_x = 100 * Scale.width
      local start_y = Screen_Size.height * 0.4
      local x = start_x
      local y = start_y
      local text = "Left"
      local t = Text(x, y, text, font)
      UI:add(t)
      local i = Icon(x + (10 * Scale.width) + ((font:getWidth(text)) * Scale.width), y, keys["a"])
      UI:add(i)
      i = Icon(x + (10 * Scale.width) + ((font:getWidth(text)) * Scale.width) + (50 * Scale.width), y, keys["s"])
      UI:add(i)
      x = start_x + (10 * Scale.width) + ((font:getWidth(text)) * Scale.width) + (50 * Scale.width)
      y = start_y + (36 * Scale.height)
      text = "Down"
      t = Text(x, y, text, font)
      UI:add(t)
      x = start_x + (10 * Scale.width) + ((font:getWidth("Left")) * Scale.width) + (100 * Scale.width)
      y = start_y
      i = Icon(x, y, keys["d"])
      UI:add(i)
      text = "Right"
      t = Text(x + ((font:getWidth(text)) * Scale.width), y, text, font)
      UI:add(t)
      x = start_x
      y = start_y
      i = Icon(x + (10 * Scale.width) + ((font:getWidth("Left")) * Scale.width) + (50 * Scale.width), y - (46 * Scale.height), keys["w"])
      UI:add(i)
      text = "Up"
      t = Text(x + (10 * Scale.width) + ((font:getWidth("Left")) * Scale.width) + (50 * Scale.width), y - (82 * Scale.height), text, font)
      UI:add(t)
      x = (Screen_Size.width / 3) - (100 * Scale.width)
      y = start_y - (46 * Scale.height)
      i = Icon(x, y, keys["p"])
      UI:add(i)
      text = "Pause"
      t = Text(x, y - (36 * Scale.height), text, font)
      UI:add(t)
      x = ((Screen_Size.width / 3) * 2) + (200 * Scale.width)
      y = start_y - (46 * Scale.height)
      i = Icon(x, y, keys["e"])
      UI:add(i)
      text = "Toggle Turret"
      t = Text(x, y - (36 * Scale.height), text, font)
      UI:add(t)
      x = ((Screen_Size.width / 3) * 2) + (200 * Scale.width)
      y = start_y
      i = Icon(x, y, keys["space"])
      UI:add(i)
      text = "Place/Repair Turret"
      t = Text(x, y + (36 * Scale.height), text, font)
      UI:add(t)
      x = (Screen_Size.width / 3) - (100 * Scale.width)
      y = start_y + (46 * Scale.height)
      i = Icon(x, y, keys["z"])
      UI:add(i)
      text = "Toggle Range"
      t = Text(x, y + (36 * Scale.height), text, font)
      return UI:add(t)
    end,
    createMainMenu = function(self)
      UI:set_screen(Screen_State.main_menu)
      self:createHelp()
      local title = Text(Screen_Size.width / 2, (Screen_Size.height / 4), "Tower Defense")
      UI:add(title)
      local start_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) - (32 * Scale.height), 250, 60, "Start", function()
        Driver.game_state = Game_State.playing
        return UI:set_screen(Screen_State.none)
      end)
      UI:add(start_button)
      local exit_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) + (32 * Scale.height), 250, 60, "Exit", function()
        return love.event.quit(0)
      end)
      return UI:add(exit_button)
    end,
    createPauseMenu = function(self)
      UI:set_screen(Screen_State.pause_menu)
      self:createHelp()
      local title = Text(Screen_Size.width / 2, (Screen_Size.height / 3), "Game Paused")
      UI:add(title)
      local names = {
        "Basic",
        "Player",
        "Spawner",
        "Strong",
        "Turret"
      }
      local sprites = {
        (Sprite("enemy/tracker.tga", 32, 32, 1, 1.25)),
        (Sprite("enemy/enemy.tga", 26, 26, 1, 0.75)),
        (Sprite("projectile/dart.tga", 17, 17, 1, 2)),
        (Sprite("enemy/bullet.tga", 26, 20, 1, 2)),
        (Sprite("enemy/circle.tga", 26, 26, 1, 1.75))
      }
      for i = 1, #names do
        local x = map(i, 1, #names, 100 * Scale.width, Screen_Size.width - (200 * Scale.width))
        local y = Screen_Size.height * 0.8
        local icon = Icon(x, y, sprites[i])
        UI:add(icon)
        local bounds = sprites[i]:getBounds(x, y)
        local font = Renderer:newFont(20)
        local width = font:getWidth(names[i])
        local text = Text(x + (10 * Scale.width) + bounds.radius + (width / 2), y, names[i], font)
        UI:add(text)
      end
      local resume_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) - (32 * Scale.height), 250, 60, "Resume", function()
        return Driver.unpause()
      end)
      UI:add(resume_button)
      local restart_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) + (38 * Scale.height), 250, 60, "Restart", function()
        return Driver.restart()
      end)
      UI:add(restart_button)
      local quit_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) + (108 * Scale.height), 250, 60, "Quit", function()
        return love.event.quit(0)
      end)
      return UI:add(quit_button)
    end,
    createGameOverMenu = function(self)
      UI:set_screen(Screen_State.game_over)
      local title = Text(Screen_Size.width / 2, (Screen_Size.height / 2), "YOU LOSE!", Renderer.giant_font)
      UI:add(title)
      local restart_button = Button(Screen_Size.width / 2, Screen_Size.height - (200 * Scale.height), 250, 60, "Restart", function()
        return Driver.restart()
      end)
      UI:add(restart_button)
      local quit_button = Button(Screen_Size.width / 2, Screen_Size.height - (130 * Scale.height), 250, 60, "Quit", function()
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
      local title = Text(Screen_Size.width / 2, 25 * Scale.height, "Upgrade")
      UI:add(title)
      UI:add(Text(100 * Scale.width, 100 * Scale.width, "Player", Renderer.hud_font))
      local stats = {
        "Health",
        "Range",
        "Damage",
        "Speed",
        "Special"
      }
      for k, v in pairs(stats) do
        local y = (100 + (k * 65)) * Scale.height
        UI:add(Text(200 * Scale.width, y, v, Renderer.small_font))
        if k ~= 5 then
          local b = TooltipButton(280 * Scale.width, y, 30, 30, "+", (function()
            return Upgrade:add_skill(Upgrade_Trees.player_stats, k)
          end), nil, {
            tt,
            tt2
          })
          UI:add(b)
        else
          local specials = {
            "1",
            "2",
            "3",
            "4"
          }
          for k, v in pairs(specials) do
            local x = (280 + ((k - 1) * 100)) * Scale.width
            local b = Button(x, y, 50, 30, v, function()
              return Upgrade:add_skill(Upgrade_Trees.player_special, k)
            end)
            UI:add(b)
          end
        end
      end
      UI:add(Text(100 * Scale.width, 500 * Scale.height, "Turret", Renderer.hud_font))
      stats = {
        "Health",
        "Range",
        "Damage",
        "Cooldown",
        "Special"
      }
      for k, v in pairs(stats) do
        local y = (500 + (k * 65)) * Scale.height
        UI:add(Text(200 * Scale.width, y, v, Renderer.small_font))
        if k ~= 5 then
          local b = TooltipButton(280 * Scale.width, y, 30, 30, "+", (function()
            return Upgrade:add_skill(Upgrade_Trees.turret_stats, k)
          end), nil, {
            tt,
            tt2
          })
          UI:add(b)
        else
          local specials = {
            "1",
            "2",
            "3",
            "4"
          }
          for k, v in pairs(specials) do
            local x = (280 + ((k - 1) * 100)) * Scale.width
            local b = Button(x, y, 50, 30, v, function()
              return Upgrade:add_skill(Upgrade_Trees.turret_special, k)
            end)
            UI:add(b)
          end
        end
      end
      local continue_button = Button(Screen_Size.width / 2, Screen_Size.height - (35 * Scale.height), 200, 50, "Continue", function()
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
      self:createPauseMenu()
      self:createGameOverMenu()
      self:createUpgradeMenu()
      return self:createMainMenu()
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
