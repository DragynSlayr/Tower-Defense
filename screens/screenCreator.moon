export class ScreenCreator
  new: =>
    @createControlsMenu!
    @createSettingsMenu!
    @createGameOverMenu!
    @createUpgradeMenu!
    @createInventoryMenu!
    @createPauseMenu!
    @createMainMenu!

  createControlsMenu: =>
    UI\set_screen Screen_State.controls

    y = 0.1
    for k, v in pairs Controls.key_names
      key = split v, "_"
      key = toTitle (key[1] .. " " .. key[2])
      UI\add (Text Screen_Size.width * 0.45, Screen_Size.height * y, key, (Renderer\newFont 20))
      b = Button Screen_Size.width * 0.55, Screen_Size.height * y, 125, 35, Controls.keys[v], nil, (Renderer\newFont 20)
      b.action = (() ->
        Controls.selected = k
        Controls.button = b
        Controls.selected_text = key
      )
      UI\add b
      y += 0.055

    back_button = Button Screen_Size.width / 2, Screen_Size.height - (34 * Scale.height), 250, 60, "Back", () ->
      Driver.game_state = Game_State.settings
      UI\set_screen Screen_State.settings
    UI\add back_button

  createSettingsMenu: =>
    UI\set_screen Screen_State.settings

    _, _, current_flags = love.window.getMode!

    controls_button = Button Screen_Size.width / 2, Screen_Size.height - (162 * Scale.height), 250, 60, "Controls", () ->
      Driver.game_state = Game_State.controls
      UI\set_screen Screen_State.controls
    UI\add controls_button

    UI\add (Text Screen_Size.width * 0.45, Screen_Size.height * 0.255, "Fullscreen", (Renderer\newFont 20))
    fs_cb = CheckBox Screen_Size.width * 0.55, Screen_Size.height * 0.255, 50, nil
    fs_cb.checked = love.window.getFullscreen!
    UI\add fs_cb

    UI\add (Text Screen_Size.width * 0.45, Screen_Size.height * 0.31, "Vertical Sync", (Renderer\newFont 20))
    vs_cb = CheckBox Screen_Size.width * 0.55, Screen_Size.height * 0.31, 50, nil
    vs_cb.checked = current_flags.vsync
    UI\add vs_cb

    UI\add (Text Screen_Size.width * 0.45, Screen_Size.height * 0.365, "Show FPS", (Renderer\newFont 20))
    fps_cb = CheckBox Screen_Size.width * 0.55, Screen_Size.height * 0.365, 50, nil
    fps_cb.checked = SHOW_FPS
    UI\add fps_cb

    UI\add (Text Screen_Size.width * 0.45, Screen_Size.height * 0.41, "Resolution", (Renderer\newFont 20))
    resolutions = {
      "1920 x 1080",
      "1600 x 900",
      "1366 x 768",
      "1280 x 1024",
      "1024 x 768",
      "800 x 600"
    }
    current_res = Screen_Size.width .. " x " .. Screen_Size.height
    if not (tableContains resolutions, current_res)
      table.insert resolutions, current_res
      table.sort resolutions, (a, b) ->
        return (tonumber (split a, " ")[1]) > (tonumber (split b, " ")[1])
    res_cb = ComboBox Screen_Size.width * 0.55, Screen_Size.height * 0.41, 125, 35, resolutions, (Renderer\newFont 20)
    res_cb.text = current_res
    UI\add res_cb

    apply_button = Button Screen_Size.width / 2, Screen_Size.height - (98 * Scale.height), 250, 60, "Apply", () ->
      new_res = split res_cb.text, " "
      new_width = tonumber new_res[1]
      new_height = tonumber new_res[3]

      res_changed = new_width ~= Screen_Size.width or new_height ~= Screen_Size.height

      flags = {}
      flags.fullscreen = fs_cb.checked and not res_changed
      flags.vsync = vs_cb.checked

      current_width, current_height, current_flags = love.window.getMode!

      num_diff = 0
      if flags.fullscreen ~= current_flags.fullscreen
        num_diff += 1
      if flags.vsync ~= current_flags.vsync
        num_diff += 1
      if new_width ~= current_width
        num_diff += 1
      if new_height ~= current_height
        num_diff += 1

      if num_diff > 0
        love.window.setMode new_width, new_height, flags

      calcScreen!

      export SHOW_FPS = fps_cb.checked

      if fs_cb.checked and not res_changed
        writeKey "FULLSCREEN", "1"
      else
        writeKey "FULLSCREEN", "0"

      writeKey "WIDTH", (tostring new_width)
      writeKey "HEIGHT", (tostring new_height)

      if vs_cb.checked
        writeKey "VSYNC", "1"
      else
        writeKey "VSYNC", "0"

      if fps_cb.checked
        writeKey "SHOW_FPS", "1"
      else
        writeKey "SHOW_FPS", "0"

      Driver\restart!
    UI\add apply_button

    back_button = Button Screen_Size.width / 2, Screen_Size.height - (34 * Scale.height), 250, 60, "Back", () ->
      Driver.game_state = Game_State.none
      UI\set_screen Screen_State.main_menu
    UI\add back_button

  createMainMenu: =>
    UI\set_screen Screen_State.main_menu

    title = Text Screen_Size.width / 2, (Screen_Size.height / 4), "Tower Defense"
    UI\add title

    start_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) - (32 * Scale.height), 250, 60, "Start", () ->
      Driver.game_state = Game_State.playing
      UI\set_screen Screen_State.none
    UI\add start_button

    settings_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + (32 * Scale.height), 250, 60, "Settings", () ->
      Driver.game_state = Game_State.settings
      UI\set_screen Screen_State.settings
    UI\add settings_button

    exit_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + (96 * Scale.height), 250, 60, "Exit", () ->
      Driver.quitGame!
    UI\add exit_button

  createPauseMenu: =>
    UI\set_screen Screen_State.pause_menu

    title = Text Screen_Size.width / 2, (Screen_Size.height / 3), "Game Paused"
    UI\add title

    sprite = Sprite "player/test.tga", 16, 16, 2, 50 / 16
    sprite\setRotationSpeed -math.pi / 2
    x = Screen_Size.width * 0.05--0.20
    y = Screen_Size.height * 0.4
    icon = Icon x, y, sprite
    UI\add icon
    bounds = sprite\getBounds x, y
    font = Renderer\newFont 20
    width = font\getWidth "Player"
    text = Text x + (10 * Scale.width) + bounds.radius + (width / 2), y, "Player", font
    UI\add text

    sprite = Sprite "turret/turret.tga", 34, 16, 2, 50 / 34
    x = Screen_Size.width * 0.90--0.80
    y = Screen_Size.height * 0.4
    icon = Icon x, y, sprite
    UI\add icon
    bounds = sprite\getBounds x, y
    font = Renderer\newFont 20
    width = font\getWidth "Turret"
    text = Text x + (10 * Scale.width) + bounds.radius + (width / 2), y, "Turret", font
    UI\add text

    resume_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) - (32 * Scale.height), 250, 60, "Resume", () ->
      Driver.unpause!
    UI\add resume_button

    restart_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + (32 * Scale.height), 250, 60, "Restart", () ->
      ScoreTracker\saveScores!
      Driver.restart!
    UI\add restart_button

    quit_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + (96 * Scale.height), 250, 60, "Quit", () ->
      Driver.quitGame!
    UI\add quit_button

    left_button = Button Screen_Size.width * 0.45, (Screen_Size.height * 0.76), 64, 64, "", () ->
      Pause\previousLayer!
    left_button\setSprite (Sprite "ui/button/left_idle.tga", 32, 32, 1, 1), (Sprite "ui/button/left_click.tga", 32, 32, 1, 1)
    UI\add left_button

    right_button = Button Screen_Size.width * 0.55, (Screen_Size.height * 0.76), 64, 64, "", () ->
      Pause\nextLayer!
    right_button\setSprite (Sprite "ui/button/right_idle.tga", 32, 32, 1, 1), (Sprite "ui/button/right_click.tga", 32, 32, 1, 1)
    UI\add right_button

  createGameOverMenu: =>
    UI\set_screen Screen_State.game_over

    title = Text Screen_Size.width / 2, (Renderer\newFont 250)\getHeight! / 2, "GAME OVER", (Renderer\newFont 250)
    UI\add title

    restart_button = Button (Screen_Size.width / 2) - (127.5 * Scale.width), Screen_Size.height - (35 * Scale.height), 250, 60, "Restart", () ->
      ScoreTracker\saveScores!
      Driver.restart!
    UI\add restart_button

    quit_button = Button (Screen_Size.width / 2) + (127.5 * Scale.width), Screen_Size.height - (35 * Scale.height), 250, 60, "Quit", () ->
      Driver.quitGame!
    UI\add quit_button

  createUpgradeMenu: =>
    UI\set_screen Screen_State.upgrade

    bg = Background {255, 255, 255, 255}--{8, 167, 0, 255}
    UI\add bg

    title = Text Screen_Size.width / 2, 25 * Scale.height, "Upgrade"
    UI\add title

    names = {"Player", "Turret"}
    stats = {
      {"Health", "Range", "Damage", "Speed", "Rate of Fire"},--, "Special"},
      {"Health", "Range", "Damage", "Cooldown", "Attack Delay"}--, "Special"}
    }
    num_stats = 5
    trees = {Upgrade_Trees.player_stats, Upgrade_Trees.turret_stats}--, Upgrade_Trees.player_special, Upgrade_Trees.turret_special}
    --specials = {{"Life Steal", "Range Boost", "Missile", "Speed Boost"}, {"Extra Turret", "Shield", "Multiple Targets", "Burst"}}
    --num_specials = 4
    --descriptions = {
    --  {"Recover life from hit enemies", "Double player range near turret", "A homing missile spawns periodically", "Player speed increases for every enemy near them"},
    --  {"Up to 2 turrets can be placed", "Allies receive a temporary shield when a turret gets to half health", "Turret can hit more than a single enemy", "A barrage of bullets is fired when placed"}
    --}
    --width = 0
    font = Renderer\newFont 15
    font2 = Renderer\newFont 20

    --for k, v in pairs specials
    --  for k2, v2 in pairs v
    --    w = font\getWidth v2
    --    if w >= width
    --      width = w

    --width *= 1.1

    for i = 1, 2
      mod = i - 1
      y = Screen_Size.height / 4
      space = 425 * Scale.height
      UI\add Text (90 - (5 * mod)) * Scale.width, y + (space * mod), names[i], (Renderer\newFont 30)

      for j = 1, num_stats
        y = (25 + (j * 65) + (425 * mod)) * Scale.height
        UI\add Text (0.5 * Screen_Size.width) - (400 * Scale.width), y, stats[i][j], (Renderer\newFont 20)
        --if j ~= num_stats
        stats_table = Upgrade.player_stats
        current_stats = Stats.player
        if i == 2
          stats_table = Upgrade.turret_stats
          current_stats = Stats.turret
        tt = Tooltip (0.5 * Screen_Size.width) + (375 * Scale.width), y, (() =>
          level = stats_table[j]
          if level == Upgrade.max_skill
            return "Upgrade Complete!"
          else
            modifier = 0
            if level > 0
              modifier = Upgrade.amount[i][j][level]

            amount = 0
            amount = Upgrade.amount[i][j][level + 1] - modifier
            --if i == 1 and j == 5
            --if j == 5
            --  amount /= stats_table[j] + 1
            --else
            amount /= current_stats[j]
            amount *= 100

            message = "  " .. names[i] .. "  " .. stats[i][j] .. "  by  " .. (string.format "%d", math.floor math.abs amount) .. "%"
            if amount < 0
              message = "Decrease" .. message
            else
              message = "Increase" .. message
            return message
        ), font2
        ttb = TooltipBox Screen_Size.half_width - (250 * Scale.width), y + (0 * Scale.height), 100 * Scale.width, 40 * Scale.height, (() =>
          if not @index
            @index = 1
          return Upgrade.upgrade_cost[@index]
        )
        b = TooltipButton (0.5 * Screen_Size.width) + (340 * Scale.width), y, 50, 50, "+", (() ->
          result = Upgrade\addSkill trees[i], j
          if result
            if ttb.index < #Upgrade.upgrade_cost
              ttb.index += 1
              ttb.x += ttb.width
            else
              ttb.blocked = true
        ), nil, {tt, ttb}
        UI\add b
        UI\add tt
        UI\add ttb
        --else
        --  x = (0.5 * Screen_Size.width) - (260 * Scale.width)
        --  for k = 1, num_specials
        --    special_table = Upgrade.player_special
        --    if i == 2
        --      special_table = Upgrade.turret_special
        --    tt = Tooltip x - ((font\getWidth descriptions[i][k]) / 2), y - (30 * Scale.height), (() =>
        --      return descriptions[i][k]
        --    ), font
        --    b = TooltipButton x, y, width + 10, 30, specials[i][k], (() =>
        --      result = Upgrade\addSkill trees[2 + i], k
        --      @active = not result
        --    ), font, {tt}
        --    x += b.width + (10 * Scale.width)
        --    UI\add b
        --    UI\add tt
        --    UI\add tt2

    --Button Screen_Size.width - (370 * Scale.width), Screen_Size.height - (32 * Scale.height)

    inventory_button = Button Screen_Size.width - (150 * Scale.width), Screen_Size.height - (32 * Scale.height), 200, 45, "Inventory", () ->
      UI\set_screen Screen_State.inventory
      Driver.game_state = Game_State.inventory
    UI\add inventory_button

    continue_button = Button Screen_Size.width - (150 * Scale.width), Screen_Size.height - (32 * Scale.height), 200, 45, "Continue", () ->
      UI\set_screen Screen_State.none
      Driver.game_state = Game_State.playing
      Driver\respawnPlayers!
      Objectives\nextMode!
    --UI\add continue_button

  createInventoryMenu: =>
    UI\set_screen Screen_State.inventory

    bg = Background {255, 255, 255, 255}--{8, 167, 0, 255}
    UI\add bg

    title = Text Screen_Size.width / 2, 25 * Scale.height, "Inventory"
    UI\add title

    passive_text = Text Screen_Size.width * 0.60, Screen_Size.height * 0.15, "Passives", (Renderer\newFont 30)
    UI\add passive_text

    active_text = Text Screen_Size.width * 0.15, Screen_Size.height * 0.15, "Active", (Renderer\newFont 30)
    UI\add active_text

    active_item_frame = ItemFrame Screen_Size.width * 0.15, (Screen_Size.height * 0.15) + (125 * Scale.height)
    active_item_frame.frameType = ItemFrameTypes.active
    UI\add active_item_frame

    passive_grid = ItemGrid Screen_Size.width * 0.4, (Screen_Size.height * 0.15) + (125 * Scale.height)
    UI\add passive_grid

    Pause.item_grid = passive_grid

    up_button = Button Screen_Size.width * 0.9, (Screen_Size.height * 0.6) - (40 * Scale.width), 64, 64, "", () ->
      passive_grid\nextLayer!
    up_button\setSprite (Sprite "ui/button/up_idle.tga", 32, 32, 1, 1), (Sprite "ui/button/up_click.tga", 32, 32, 1, 1)
    UI\add up_button

    down_button = Button Screen_Size.width * 0.9, (Screen_Size.height * 0.6) + (40 * Scale.width), 64, 64, "", () ->
      passive_grid\previousLayer!
    down_button\setSprite (Sprite "ui/button/down_idle.tga", 32, 32, 1, 1), (Sprite "ui/button/down_click.tga", 32, 32, 1, 1)
    UI\add down_button

    opened_item_frame = ItemFrame 350 * Scale.width, Screen_Size.height - (150 * Scale.height)
    opened_item_frame.frameType = ItemFrameTypes.transfer
    opened_item_frame.active_frame = active_item_frame
    opened_item_frame.passive_grid = passive_grid
    UI\add opened_item_frame

    Inventory.opened_item_frame = opened_item_frame

    open_frame = ItemFrame 150 * Scale.width, Screen_Size.height - (150 * Scale.height), (ItemBox 0, 0)
    open_frame.usable = false
    UI\add open_frame

    open_button = Button 150 * Scale.width, Screen_Size.height - (32 * Scale.height), 200, 45, "Open", () ->
      Inventory\open_box!
    UI\add open_button

    upgrade_button = Button Screen_Size.width - (370 * Scale.width), Screen_Size.height - (32 * Scale.height), 200, 45, "Upgrade", () ->
      UI\set_screen Screen_State.upgrade
      Driver.game_state = Game_State.upgrading
    UI\add upgrade_button

    continue_button = Button Screen_Size.width - (150 * Scale.width), Screen_Size.height - (32 * Scale.height), 200, 45, "Continue", () ->
      UI\set_screen Screen_State.none
      Driver.game_state = Game_State.playing
      Driver\respawnPlayers!
      Objectives\nextMode!
    UI\add continue_button

    text = Text Screen_Size.width * 0.43, (Screen_Size.height * 0.8) + (75 * Scale.height), "Item Rarity", (Renderer\newFont 30)
    UI\add text

    sprite = Sprite "ui/icons/arrow.tga", 8, 40, 1, 10
    sprite\setScale 5, 6
    arrow = Icon Screen_Size.width * 0.55, (Screen_Size.height * 0.8) + (75 * Scale.height), sprite
    UI\add arrow

    sprite = Sprite "ui/icons/spectrum.tga", 4, 20, 1, 20
    spectrum = Icon Screen_Size.width * 0.5, Screen_Size.height * 0.8, sprite
    UI\add spectrum
