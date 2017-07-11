do
  local _class_0
  local _base_0 = {
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
        "z"
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
      self:createHelp(nil, Screen_Size.height * 0.2)
      local title = Text(Screen_Size.width / 2, (Screen_Size.height / 3), "Game Paused")
      UI:add(title)
      local sprite = Sprite("player/test.tga", 16, 16, 0.29, 50 / 16)
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
      local restart_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) + (38 * Scale.height), 250, 60, "Restart", function()
        return Driver.restart()
      end)
      UI:add(restart_button)
      local quit_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) + (108 * Scale.height), 250, 60, "Quit", function()
        return love.event.quit(0)
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
          "Attack Delay",
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
          "Pickup"
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
          "Use 'E' to place another turret",
          "Allies receive a temporary shield when a turret gets to half health",
          "Turret can hit more than a single enemy",
          "Use 'E' to pickup turrets after they have been placed"
        }
      }
      local width = 0
      local font = Renderer:newFont(15)
      for k, v in pairs(specials) do
        for k2, v2 in pairs(v) do
          local w = font:getWidth(v2)
          if w >= width then
            width = w
          end
        end
      end
      for i = 1, 2 do
        local mod = i - 1
        UI:add(Text((90 - (5 * mod)) * Scale.width, (65 + (420 * mod)) * Scale.height, names[i], Renderer.hud_font))
        for j = 1, num_stats do
          local y = (25 + (j * 65) + (425 * mod)) * Scale.height
          UI:add(Text(190 * Scale.width, y, stats[i][j], Renderer.small_font))
          if j ~= num_stats then
            local stats_table = Upgrade.player_stats
            local current_stats = Stats.player
            if i == 2 then
              stats_table = Upgrade.turret_stats
              current_stats = Stats.turret
            end
            local tt = Tooltip(Screen_Size.width * (5 / 24), y - (30 * Scale.height), (function(self)
              local level = stats_table[j]
              if level == Upgrade.max_skill then
                return "Upgrade Complete!"
              else
                local modifier = 0
                if level > 0 then
                  modifier = Upgrade.amount[i][j][level]
                end
                local amount = Upgrade.amount[i][j][level + 1] - modifier
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
            end), font)
            local tt2 = Tooltip(Screen_Size.width * 0.72, y, (function(self)
              local level = stats_table[j]
              if level == Upgrade.max_skill then
                return ""
              else
                local modifier = 0
                if level > 0 then
                  modifier = Upgrade.amount[i][j][level]
                end
                local amount = Upgrade.amount[i][j][level + 1] - modifier
                local message = "("
                if amount < 0 then
                  message = message .. "-"
                else
                  message = message .. "+"
                end
                message = message .. ((string.format("%.3f", math.abs(amount))) .. ")")
                return message
              end
            end), Renderer.hud_font, "right")
            tt2.color = {
              0,
              225,
              0,
              255
            }
            local tt3 = Tooltip(Screen_Size.width * 0.95, 17.5 * Scale.height, (function(self)
              local level = stats_table[j] + 1
              if level <= Upgrade.max_skill then
                return "-" .. Upgrade.upgrade_cost[level]
              else
                return ""
              end
            end), Renderer.hud_font)
            tt3.color = {
              225,
              0,
              0,
              255
            }
            local b = TooltipButton(280 * Scale.width, y, 30, 30, "+", (function()
              return Upgrade:add_skill(trees[i], j)
            end), nil, {
              tt,
              tt2,
              tt3
            })
            UI:add(b)
            UI:add(tt)
            UI:add(tt2)
            UI:add(tt3)
          else
            local x = (280 + (width / 2)) * Scale.width
            for k = 1, num_specials do
              local special_table = Upgrade.player_special
              if i == 2 then
                special_table = Upgrade.turret_special
              end
              local tt = Tooltip(280 * Scale.width, y - (30 * Scale.height), (function(self)
                return descriptions[i][k]
              end), font)
              local tt2 = Tooltip(Screen_Size.width * 0.95, 17.5 * Scale.height, (function(self)
                if special_table[k] then
                  return ""
                else
                  return "-5"
                end
              end), Renderer.hud_font)
              tt2.color = {
                225,
                0,
                0,
                255
              }
              local b = TooltipButton(x, y, width + 10, 30, specials[i][k], (function(self)
                local result = Upgrade:add_skill(trees[2 + i], k)
                self.active = not result
              end), font, {
                tt,
                tt2
              })
              x = x + (b.width + (10 * Scale.width))
              UI:add(b)
              UI:add(tt)
              UI:add(tt2)
            end
          end
        end
      end
      local inventory_button = Button(Screen_Size.width - (370 * Scale.width), Screen_Size.height - (32 * Scale.height), 200, 45, "Inventory", function()
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
      return UI:add(continue_button)
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
      return UI:add(continue_button)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
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
