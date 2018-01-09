do
  local _base_0 = {
    createControlsMenu = function(self)
      UI:set_screen(Screen_State.controls)
      local y = 0.1
      for k, v in pairs(Controls.key_names) do
        local key = split(v, "_")
        key = toTitle((key[1] .. " " .. key[2]))
        UI:add((Text(Screen_Size.width * 0.45, Screen_Size.height * y, key, Renderer.small_font)))
        local b = Button(Screen_Size.width * 0.55, Screen_Size.height * y, 125, 35, Controls.keys[v], nil, Renderer.small_font)
        b.action = (function()
          Controls.selected = k
          Controls.button = b
          Controls.selected_text = key
        end)
        UI:add(b)
        y = y + 0.055
      end
      local back_button = Button(Screen_Size.width / 2, Screen_Size.height - (34 * Scale.height), 250, 60, "Back", function()
        Driver.game_state = Game_State.settings
        return UI:set_screen(Screen_State.settings)
      end)
      return UI:add(back_button)
    end,
    createSettingsMenu = function(self)
      UI:set_screen(Screen_State.settings)
      local _, current_flags
      _, _, current_flags = love.window.getMode()
      local controls_button = Button(Screen_Size.width / 2, Screen_Size.height - (162 * Scale.height), 250, 60, "Controls", function()
        Driver.game_state = Game_State.controls
        return UI:set_screen(Screen_State.controls)
      end)
      UI:add(controls_button)
      UI:add((Text(Screen_Size.width * 0.45, Screen_Size.height * 0.255, "Fullscreen", Renderer.small_font)))
      local fs_cb = CheckBox(Screen_Size.width * 0.55, Screen_Size.height * 0.255, 50, nil)
      fs_cb.checked = love.window.getFullscreen()
      UI:add(fs_cb)
      UI:add((Text(Screen_Size.width * 0.45, Screen_Size.height * 0.31, "Vertical Sync", Renderer.small_font)))
      local vs_cb = CheckBox(Screen_Size.width * 0.55, Screen_Size.height * 0.31, 50, nil)
      vs_cb.checked = current_flags.vsync
      UI:add(vs_cb)
      UI:add((Text(Screen_Size.width * 0.45, Screen_Size.height * 0.365, "Show FPS", Renderer.small_font)))
      local fps_cb = CheckBox(Screen_Size.width * 0.55, Screen_Size.height * 0.365, 50, nil)
      fps_cb.checked = SHOW_FPS
      UI:add(fps_cb)
      UI:add((Text(Screen_Size.width * 0.45, Screen_Size.height * 0.41, "Resolution", Renderer.small_font)))
      local resolutions = {
        "1920 x 1080",
        "1600 x 900",
        "1366 x 768",
        "1280 x 1024",
        "1024 x 768",
        "800 x 600"
      }
      local current_res = Screen_Size.width .. " x " .. Screen_Size.height
      if not (tableContains(resolutions, current_res)) then
        table.insert(resolutions, current_res)
        table.sort(resolutions, function(a, b)
          return (tonumber((split(a, " "))[1])) > (tonumber((split(b, " "))[1]))
        end)
      end
      local res_cb = ComboBox(Screen_Size.width * 0.55, Screen_Size.height * 0.41, 125, 35, resolutions, Renderer.small_font)
      res_cb.text = current_res
      UI:add(res_cb)
      local apply_button = Button(Screen_Size.width / 2, Screen_Size.height - (98 * Scale.height), 250, 60, "Apply", function()
        local new_res = split(res_cb.text, " ")
        local new_width = tonumber(new_res[1])
        local new_height = tonumber(new_res[3])
        local res_changed = new_width ~= Screen_Size.width or new_height ~= Screen_Size.height
        local flags = { }
        flags.fullscreen = fs_cb.checked and not res_changed
        flags.vsync = vs_cb.checked
        local current_width, current_height
        current_width, current_height, current_flags = love.window.getMode()
        local num_diff = 0
        if flags.fullscreen ~= current_flags.fullscreen then
          num_diff = num_diff + 1
        end
        if flags.vsync ~= current_flags.vsync then
          num_diff = num_diff + 1
        end
        if new_width ~= current_width then
          num_diff = num_diff + 1
        end
        if new_height ~= current_height then
          num_diff = num_diff + 1
        end
        if num_diff > 0 then
          love.window.setMode(new_width, new_height, flags)
        end
        calcScreen()
        SHOW_FPS = fps_cb.checked
        if fs_cb.checked and not res_changed then
          writeKey("FULLSCREEN", "1")
        else
          writeKey("FULLSCREEN", "0")
        end
        writeKey("WIDTH", (tostring(new_width)))
        writeKey("HEIGHT", (tostring(new_height)))
        if vs_cb.checked then
          writeKey("VSYNC", "1")
        else
          writeKey("VSYNC", "0")
        end
        if fps_cb.checked then
          writeKey("SHOW_FPS", "1")
        else
          writeKey("SHOW_FPS", "0")
        end
        return Driver:restart()
      end)
      UI:add(apply_button)
      local back_button = Button(Screen_Size.width / 2, Screen_Size.height - (34 * Scale.height), 250, 60, "Back", function()
        Driver.game_state = Game_State.none
        return UI:set_screen(Screen_State.main_menu)
      end)
      return UI:add(back_button)
    end,
    createMainMenu = function(self)
      UI:set_screen(Screen_State.main_menu)
      local title = Text(Screen_Size.width / 2, (Screen_Size.height / 4), "Tower Defense")
      UI:add(title)
      local start_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) - (32 * Scale.height), 250, 60, "Start", function()
        Driver.game_state = Game_State.playing
        return UI:set_screen(Screen_State.none)
      end)
      UI:add(start_button)
      local settings_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) + (32 * Scale.height), 250, 60, "Settings", function()
        Driver.game_state = Game_State.settings
        return UI:set_screen(Screen_State.settings)
      end)
      UI:add(settings_button)
      local exit_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) + (96 * Scale.height), 250, 60, "Exit", function()
        return Driver.quitGame()
      end)
      return UI:add(exit_button)
    end,
    createPauseMenu = function(self)
      UI:set_screen(Screen_State.pause_menu)
      local title = Text(Screen_Size.width / 2, (Screen_Size.height / 3), "Game Paused")
      UI:add(title)
      local sprite = Sprite("player/test.tga", 16, 16, 2, 50 / 16)
      sprite:setRotationSpeed(-math.pi / 2)
      local x = Screen_Size.width * 0.05
      local y = Screen_Size.height * 0.4
      local icon = Icon(x, y, sprite)
      UI:add(icon)
      local bounds = sprite:getBounds(x, y)
      local font = Renderer:newFont(20)
      local width = font:getWidth("Player")
      local text = Text(x + (10 * Scale.width) + bounds.radius + (width / 2), y, "Player", font)
      UI:add(text)
      sprite = Sprite("turret/turret.tga", 34, 16, 2, 50 / 34)
      x = Screen_Size.width * 0.90
      y = Screen_Size.height * 0.4
      icon = Icon(x, y, sprite)
      UI:add(icon)
      bounds = sprite:getBounds(x, y)
      font = Renderer:newFont(20)
      width = font:getWidth("Turret")
      text = Text(x + (10 * Scale.width) + bounds.radius + (width / 2), y, "Turret", font)
      UI:add(text)
      local resume_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) - (32 * Scale.height), 250, 60, "Resume", function()
        return Driver.unpause()
      end)
      UI:add(resume_button)
      local restart_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) + (32 * Scale.height), 250, 60, "Restart", function()
        ScoreTracker:saveScores()
        return Driver.restart()
      end)
      UI:add(restart_button)
      local quit_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) + (96 * Scale.height), 250, 60, "Quit", function()
        return Driver.quitGame()
      end)
      UI:add(quit_button)
      local left_button = Button(Screen_Size.width * 0.45, (Screen_Size.height * 0.76), 64, 64, "", function()
        return Pause:previousLayer()
      end)
      left_button:setSprite((Sprite("ui/button/left_idle.tga", 32, 32, 1, 1)), (Sprite("ui/button/left_click.tga", 32, 32, 1, 1)))
      UI:add(left_button)
      local right_button = Button(Screen_Size.width * 0.55, (Screen_Size.height * 0.76), 64, 64, "", function()
        return Pause:nextLayer()
      end)
      right_button:setSprite((Sprite("ui/button/right_idle.tga", 32, 32, 1, 1)), (Sprite("ui/button/right_click.tga", 32, 32, 1, 1)))
      return UI:add(right_button)
    end,
    createGameOverMenu = function(self)
      UI:set_screen(Screen_State.game_over)
      local title = Text(Screen_Size.width / 2, Renderer.giant_font:getHeight() / 2, "GAME OVER", Renderer.giant_font)
      UI:add(title)
      local restart_button = Button((Screen_Size.width / 2) - (127.5 * Scale.width), Screen_Size.height - (35 * Scale.height), 250, 60, "Restart", function()
        ScoreTracker:saveScores()
        return Driver.restart()
      end)
      UI:add(restart_button)
      local quit_button = Button((Screen_Size.width / 2) + (127.5 * Scale.width), Screen_Size.height - (35 * Scale.height), 250, 60, "Quit", function()
        return Driver.quitGame()
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
      local names = {
        "Player",
        "Turret"
      }
      local stats = {
        {
          "Health",
          "Range",
          "Damage",
          "Speed",
          "Rate of Fire",
          "Special"
        },
        {
          "Health",
          "Range",
          "Damage",
          "Cooldown",
          "Attack Delay",
          "Special"
        }
      }
      local num_stats = 6
      local trees = {
        Upgrade_Trees.player_stats,
        Upgrade_Trees.turret_stats,
        Upgrade_Trees.player_special,
        Upgrade_Trees.turret_special
      }
      local specials = {
        {
          "Life Steal",
          "Range Boost",
          "Missile",
          "Speed Boost"
        },
        {
          "Extra Turret",
          "Shield",
          "Multiple Targets",
          "Burst"
        }
      }
      local num_specials = 4
      local descriptions = {
        {
          "Recover life from hit enemies",
          "Double player range near turret",
          "A homing missile spawns periodically",
          "Player speed increases for every enemy near them"
        },
        {
          "Up to 2 turrets can be placed",
          "Allies receive a temporary shield when a turret gets to half health",
          "Turret can hit more than a single enemy",
          "A barrage of bullets is fired when placed"
        }
      }
      local width = 0
      local font = Renderer:newFont(15)
      local font2 = Renderer:newFont(20)
      for k, v in pairs(specials) do
        for k2, v2 in pairs(v) do
          local w = font:getWidth(v2)
          if w >= width then
            width = w
          end
        end
      end
      width = width * 1.1
      for i = 1, 2 do
        local mod = i - 1
        local y = Screen_Size.height / 4
        local space = 425 * Scale.height
        UI:add(Text((90 - (5 * mod)) * Scale.width, y + (space * mod), names[i], Renderer.hud_font))
        for j = 1, num_stats do
          y = (25 + (j * 65) + (425 * mod)) * Scale.height
          UI:add(Text((0.5 * Screen_Size.width) - (400 * Scale.width), y, stats[i][j], Renderer.small_font))
          if j ~= num_stats then
            local stats_table = Upgrade.player_stats
            local current_stats = Stats.player
            if i == 2 then
              stats_table = Upgrade.turret_stats
              current_stats = Stats.turret
            end
            local tt = Tooltip((0.5 * Screen_Size.width) + (375 * Scale.width), y, (function(self)
              local level = stats_table[j]
              if level == Upgrade.max_skill then
                return "Upgrade Complete!"
              else
                local modifier = 0
                if level > 0 then
                  modifier = Upgrade.amount[i][j][level]
                end
                local amount = 0
                amount = Upgrade.amount[i][j][level + 1] - modifier
                amount = amount / current_stats[j]
                amount = amount * 100
                local message = "  " .. names[i] .. "  " .. stats[i][j] .. "  by  " .. (string.format("%d", math.floor(math.abs(amount)))) .. "%"
                if amount < 0 then
                  message = "Decrease" .. message
                else
                  message = "Increase" .. message
                end
                return message
              end
            end), font2)
            local ttb = TooltipBox(Screen_Size.half_width - (250 * Scale.width), y + (0 * Scale.height), 100 * Scale.width, 40 * Scale.height, (function(self)
              if not self.index then
                self.index = 1
              end
              return Upgrade.upgrade_cost[self.index]
            end))
            local b = TooltipButton((0.5 * Screen_Size.width) + (340 * Scale.width), y, 50, 50, "+", (function()
              local result = Upgrade:addSkill(trees[i], j)
              if result then
                if ttb.index < #Upgrade.upgrade_cost then
                  ttb.index = ttb.index + 1
                  ttb.x = ttb.x + ttb.width
                else
                  ttb.blocked = true
                end
              end
            end), nil, {
              tt,
              ttb
            })
            UI:add(b)
            UI:add(tt)
            UI:add(ttb)
          else
            local x = (0.5 * Screen_Size.width) - (260 * Scale.width)
            for k = 1, num_specials do
              local special_table = Upgrade.player_special
              if i == 2 then
                special_table = Upgrade.turret_special
              end
              local tt = Tooltip(x - ((font:getWidth(descriptions[i][k])) / 2), y - (30 * Scale.height), (function(self)
                return descriptions[i][k]
              end), font)
              local b = TooltipButton(x, y, width + 10, 30, specials[i][k], (function(self)
                local result = Upgrade:addSkill(trees[2 + i], k)
                self.active = not result
              end), font, {
                tt
              })
              x = x + (b.width + (10 * Scale.width))
              UI:add(b)
              UI:add(tt)
              UI:add(tt2)
            end
          end
        end
      end
      local inventory_button = Button(Screen_Size.width - (150 * Scale.width), Screen_Size.height - (32 * Scale.height), 200, 45, "Inventory", function()
        UI:set_screen(Screen_State.inventory)
        Driver.game_state = Game_State.inventory
      end)
      UI:add(inventory_button)
      local continue_button = Button(Screen_Size.width - (150 * Scale.width), Screen_Size.height - (32 * Scale.height), 200, 45, "Continue", function()
        UI:set_screen(Screen_State.none)
        Driver.game_state = Game_State.playing
        Driver:respawnPlayers()
        return Objectives:nextMode()
      end)
    end,
    createInventoryMenu = function(self)
      UI:set_screen(Screen_State.inventory)
      local bg = Background({
        255,
        255,
        255,
        255
      })
      UI:add(bg)
      local title = Text(Screen_Size.width / 2, 25 * Scale.height, "Inventory")
      UI:add(title)
      local passive_text = Text(Screen_Size.width * 0.60, Screen_Size.height * 0.15, "Passives", Renderer.hud_font)
      UI:add(passive_text)
      local active_text = Text(Screen_Size.width * 0.15, Screen_Size.height * 0.15, "Active", Renderer.hud_font)
      UI:add(active_text)
      local active_item_frame = ItemFrame(Screen_Size.width * 0.15, (Screen_Size.height * 0.15) + (125 * Scale.height))
      active_item_frame.frameType = ItemFrameTypes.active
      UI:add(active_item_frame)
      local passive_grid = ItemGrid(Screen_Size.width * 0.4, (Screen_Size.height * 0.15) + (125 * Scale.height))
      UI:add(passive_grid)
      Pause.item_grid = passive_grid
      local up_button = Button(Screen_Size.width * 0.9, (Screen_Size.height * 0.6) - (40 * Scale.width), 64, 64, "", function()
        return passive_grid:nextLayer()
      end)
      up_button:setSprite((Sprite("ui/button/up_idle.tga", 32, 32, 1, 1)), (Sprite("ui/button/up_click.tga", 32, 32, 1, 1)))
      UI:add(up_button)
      local down_button = Button(Screen_Size.width * 0.9, (Screen_Size.height * 0.6) + (40 * Scale.width), 64, 64, "", function()
        return passive_grid:previousLayer()
      end)
      down_button:setSprite((Sprite("ui/button/down_idle.tga", 32, 32, 1, 1)), (Sprite("ui/button/down_click.tga", 32, 32, 1, 1)))
      UI:add(down_button)
      local opened_item_frame = ItemFrame(350 * Scale.width, Screen_Size.height - (150 * Scale.height))
      opened_item_frame.frameType = ItemFrameTypes.transfer
      opened_item_frame.active_frame = active_item_frame
      opened_item_frame.passive_grid = passive_grid
      UI:add(opened_item_frame)
      Inventory.opened_item_frame = opened_item_frame
      local open_frame = ItemFrame(150 * Scale.width, Screen_Size.height - (150 * Scale.height), (ItemBox(0, 0)))
      open_frame.usable = false
      UI:add(open_frame)
      local open_button = Button(150 * Scale.width, Screen_Size.height - (32 * Scale.height), 200, 45, "Open", function()
        return Inventory:open_box()
      end)
      UI:add(open_button)
      local upgrade_button = Button(Screen_Size.width - (370 * Scale.width), Screen_Size.height - (32 * Scale.height), 200, 45, "Upgrade", function()
        UI:set_screen(Screen_State.upgrade)
        Driver.game_state = Game_State.upgrading
      end)
      UI:add(upgrade_button)
      local continue_button = Button(Screen_Size.width - (150 * Scale.width), Screen_Size.height - (32 * Scale.height), 200, 45, "Continue", function()
        UI:set_screen(Screen_State.none)
        Driver.game_state = Game_State.playing
        Driver:respawnPlayers()
        return Objectives:nextMode()
      end)
      UI:add(continue_button)
      local text = Text(Screen_Size.width * 0.43, (Screen_Size.height * 0.8) + (75 * Scale.height), "Item Rarity", (Renderer:newFont(25)))
      UI:add(text)
      local sprite = Sprite("ui/icons/arrow.tga", 8, 40, 1, 10)
      sprite:setScale(5, 6)
      local arrow = Icon(Screen_Size.width * 0.55, (Screen_Size.height * 0.8) + (75 * Scale.height), sprite)
      UI:add(arrow)
      sprite = Sprite("ui/icons/spectrum.tga", 4, 20, 1, 20)
      local spectrum = Icon(Screen_Size.width * 0.5, Screen_Size.height * 0.8, sprite)
      return UI:add(spectrum)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self:createControlsMenu()
      self:createSettingsMenu()
      self:createGameOverMenu()
      self:createUpgradeMenu()
      self:createInventoryMenu()
      self:createPauseMenu()
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
