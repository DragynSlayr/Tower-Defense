do
  local _class_0
  local _base_0 = {
    createControlsMenu = function(self)
      UI:set_screen(Screen_State.controls)
      self:createHelp(nil, Screen_Size.height * 0.5)
      local apply_button = Button(Screen_Size.width / 2, Screen_Size.height - (98 * Scale.height), 250, 60, "Apply", function() end)
      UI:add(apply_button)
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
      UI:add((Text(Screen_Size.width * 0.45, Screen_Size.height * 0.2, "Fullscreen", Renderer.small_font)))
      local fs_cb = CheckBox(Screen_Size.width * 0.55, Screen_Size.height * 0.2, 50, nil)
      fs_cb.checked = love.window.getFullscreen()
      UI:add(fs_cb)
      UI:add((Text(Screen_Size.width * 0.45, Screen_Size.height * 0.255, "Resolution", Renderer.small_font)))
      UI:add((Text(Screen_Size.width * 0.55, Screen_Size.height * 0.255, "X", Renderer.small_font)))
      local width_box = TextBox(Screen_Size.width * 0.495, Screen_Size.height * 0.23, 75 * Scale.width, 40 * Scale.height)
      width_box.action = { }
      width_box.active = false
      width_box.text_color = {
        255,
        255,
        255,
        255
      }
      width_box:addText((tostring(Screen_Size.width)))
      UI:add(width_box)
      local height_box = TextBox(Screen_Size.width * 0.56, Screen_Size.height * 0.23, 75 * Scale.width, 40 * Scale.height)
      height_box.action = { }
      height_box.active = false
      height_box.text_color = {
        255,
        255,
        255,
        255
      }
      height_box:addText((tostring(Screen_Size.height)))
      UI:add(height_box)
      UI:add((Text(Screen_Size.width * 0.45, Screen_Size.height * 0.31, "Vertical Sync", Renderer.small_font)))
      local vs_cb = CheckBox(Screen_Size.width * 0.55, Screen_Size.height * 0.31, 50, nil)
      vs_cb.checked = current_flags.vsync
      UI:add(vs_cb)
      local apply_button = Button(Screen_Size.width / 2, Screen_Size.height - (98 * Scale.height), 250, 60, "Apply", function()
        local new_width
        if tonumber(width_box:getText()) then
          new_width = tonumber(width_box:getText())
        else
          new_width = Screen_Size.width
        end
        local new_height
        if tonumber(height_box:getText()) then
          new_height = tonumber(height_box:getText())
        else
          new_height = Screen_Size.height
        end
        local res_changed = new_width ~= Screen_Size.width or new_height ~= Screen_Size.height
        local flags = { }
        flags.fullscreen = fs_cb.checked and not res_changed
        flags.vsync = vs_cb.checked
        love.window.setMode(new_width, new_height, flags)
        Screen_Size = { }
        Screen_Size.width = love.graphics.getWidth()
        Screen_Size.height = love.graphics.getHeight()
        Screen_Size.half_width = Screen_Size.width / 2
        Screen_Size.half_height = Screen_Size.height / 2
        Screen_Size.bounds = {
          0,
          0,
          Screen_Size.width,
          Screen_Size.height
        }
        Screen_Size.size = {
          Screen_Size.width,
          Screen_Size.height
        }
        Scale = { }
        Scale.width = Screen_Size.width / 1600
        Scale.height = Screen_Size.height / 900
        Scale.diag = math.sqrt((Screen_Size.width * Screen_Size.width) + (Screen_Size.height * Screen_Size.height)) / math.sqrt((1600 * 1600) + (900 * 900))
        Screen_Size.border = {
          0,
          70 * Scale.height,
          Screen_Size.width,
          Screen_Size.height - (140 * Scale.height)
        }
        return Driver:restart()
      end)
      UI:add(apply_button)
      local back_button = Button(Screen_Size.width / 2, Screen_Size.height - (34 * Scale.height), 250, 60, "Back", function()
        Driver.game_state = Game_State.none
        return UI:set_screen(Screen_State.main_menu)
      end)
      return UI:add(back_button)
    end,
    createHelp = function(self, start_x, start_y)
      if start_x == nil then
        start_x = 100 * Scale.width
      end
      if start_y == nil then
        start_y = Screen_Size.height * 0.4
      end
      local keys = { }
      keys["space"] = Sprite("ui/keys/space.tga", 32, 96, 1, 1)
      for k, v in pairs({
        "w",
        "a",
        "s",
        "d",
        "p",
        "e",
        "z",
        "q"
      }) do
        keys[v] = Sprite("ui/keys/" .. v .. ".tga", 32, 32, 1, 1)
      end
      local font = Renderer:newFont(20)
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
      UI:add(t)
      x = (Screen_Size.width / 3) - (100 * Scale.width)
      y = start_y
      i = Icon(x, y, keys["q"])
      UI:add(i)
      text = "Use Item"
      t = Text(x + (70 * Scale.width), y, text, font)
      return UI:add(t)
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
      self:createHelp(nil, Screen_Size.height * 0.2)
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
      local passive_text = Text(Screen_Size.width * 0.25, (Screen_Size.height / 2) + (0 * Scale.height), "Passive", Renderer.hud_font)
      UI:add(passive_text)
      local active_text = Text(Screen_Size.width * 0.75, (Screen_Size.height / 2) + (0 * Scale.height), "Active", Renderer.hud_font)
      UI:add(active_text)
      local x_positions = {
        Screen_Size.width * 0.25,
        Screen_Size.width * 0.75
      }
      y = (Screen_Size.height / 2) + (108 * Scale.height)
      for k, x in pairs(x_positions) do
        local frame = ItemFrame(x, y)
        frame:scaleUniformly(0.75)
        UI:add(frame)
        frame = ItemFrame(x - (75 * Scale.width), y + (125 * Scale.height))
        frame:scaleUniformly(0.75)
        UI:add(frame)
        frame = ItemFrame(x + (75 * Scale.width), y + (125 * Scale.height))
        frame:scaleUniformly(0.75)
        UI:add(frame)
      end
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
                if i == 1 and j == 5 then
                  amount = amount / (stats_table[j] + 1)
                else
                  amount = amount / current_stats[j]
                end
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
      local passive_text = Text(Screen_Size.width * 0.25, Screen_Size.height * 0.15, "Passive", Renderer.hud_font)
      UI:add(passive_text)
      local active_text = Text(Screen_Size.width * 0.75, Screen_Size.height * 0.15, "Active", Renderer.hud_font)
      UI:add(active_text)
      local x_positions = {
        Screen_Size.width * 0.25,
        Screen_Size.width * 0.75
      }
      local y = (Screen_Size.height * 0.15) + (125 * Scale.height)
      for k, x in pairs(x_positions) do
        local frame1 = ItemFrame(x, y)
        local frame2 = ItemFrame(x - (100 * Scale.width), y + (175 * Scale.height))
        local frame3 = ItemFrame(x + (100 * Scale.width), y + (175 * Scale.height))
        if k == 1 then
          frame1.frameType = ItemFrameTypes.equippedPassive
          frame2.frameType = ItemFrameTypes.passive
          frame3.frameType = ItemFrameTypes.passive
        else
          frame1.frameType = ItemFrameTypes.equippedActive
          frame2.frameType = ItemFrameTypes.active
          frame3.frameType = ItemFrameTypes.active
        end
        UI:add(frame1)
        UI:add(frame2)
        UI:add(frame3)
      end
      local default_item = ItemBox(0, 0)
      local open_frame = ItemFrame(150 * Scale.width, Screen_Size.height - (150 * Scale.height), default_item)
      open_frame.usable = false
      UI:add(open_frame)
      local opened_item_frame = ItemFrame(350 * Scale.width, Screen_Size.height - (150 * Scale.height))
      opened_item_frame.frameType = ItemFrameTypes.transfer
      UI:add(opened_item_frame)
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
      local sprite = Sprite("ui/icons/spectrum.tga", 4, 20, 1, 20)
      local spectrum = Icon(Screen_Size.width * 0.5, Screen_Size.height * 0.80, sprite)
      UI:add(spectrum)
      sprite = Sprite("ui/icons/arrow.tga", 8, 40, 1, 10)
      local arrow = Icon(Screen_Size.width * 0.5, (Screen_Size.height * 0.80) + (85 * Scale.height), sprite)
      UI:add(arrow)
      local text = Text(Screen_Size.width * 0.5, (Screen_Size.height * 0.80) - (60 * Scale.height), "Item Rarity", (Renderer:newFont(25)))
      return UI:add(text)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self:createControlsMenu()
      self:createSettingsMenu()
      self:createPauseMenu()
      self:createGameOverMenu()
      self:createUpgradeMenu()
      self:createInventoryMenu()
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
