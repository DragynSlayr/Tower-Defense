export class ScreenCreator
  new: =>
    @createPauseMenu!
    @createGameOverMenu!
    @createUpgradeMenu!
    @createMainMenu!

  createHelp: (start_x = 100 * Scale.width, start_y = Screen_Size.height * 0.4) =>
    keys = {}
    keys["space"] = Sprite "keys/space.tga", 32, 96, 1, 1
    for k, v in pairs {"w", "a", "s", "d", "p", "e", "z"}
      keys[v] = Sprite "keys/" .. v .. ".tga", 32, 32, 1, 1

    font = Renderer\newFont 20

    -- A key
    x = start_x
    y = start_y
    text = "Left"
    t = Text x, y, text, font
    UI\add t

    i = Icon x + (10 * Scale.width) + ((font\getWidth text) * Scale.width), y, keys["a"]
    UI\add i

    -- S key
    i = Icon x + (10 * Scale.width) + ((font\getWidth text) * Scale.width) + (50 * Scale.width), y, keys["s"]
    UI\add i

    x = start_x + (10 * Scale.width) + ((font\getWidth text) * Scale.width) + (50 * Scale.width)
    y = start_y + (36 * Scale.height)
    text = "Down"
    t = Text x, y, text, font
    UI\add t

    -- D key
    x = start_x + (10 * Scale.width) + ((font\getWidth "Left") * Scale.width) + (100 * Scale.width)
    y = start_y
    i = Icon x, y, keys["d"]
    UI\add i

    text = "Right"
    t = Text x + ((font\getWidth text) * Scale.width), y, text, font
    UI\add t

    -- W key
    x = start_x
    y = start_y
    i = Icon x + (10 * Scale.width) + ((font\getWidth "Left") * Scale.width) + (50 * Scale.width), y - (46 * Scale.height), keys["w"]
    UI\add i

    text = "Up"
    t = Text x + (10 * Scale.width) + ((font\getWidth "Left") * Scale.width) + (50 * Scale.width), y - (82 * Scale.height), text, font
    UI\add t

    -- P key
    x = (Screen_Size.width / 3) - (100 * Scale.width)
    y = start_y - (46 * Scale.height)
    i = Icon x, y, keys["p"]
    UI\add i

    text = "Pause"
    t = Text x, y - (36 * Scale.height), text, font
    UI\add t

    -- E key
    x = ((Screen_Size.width / 3) * 2) + (200 * Scale.width)
    y = start_y - (46 * Scale.height)
    i = Icon x, y, keys["e"]
    UI\add i

    text = "Toggle Turret"
    t = Text x, y - (36 * Scale.height), text, font
    UI\add t

    -- space key
    x = ((Screen_Size.width / 3) * 2) + (200 * Scale.width)
    y = start_y
    i = Icon x, y, keys["space"]
    UI\add i

    text = "Place/Repair Turret"
    t = Text x, y + (36 * Scale.height), text, font
    UI\add t

    -- Z key
    x = (Screen_Size.width / 3) - (100 * Scale.width)
    y = start_y + (46 * Scale.height)
    i = Icon x, y, keys["z"]
    UI\add i

    text = "Toggle Range"
    t = Text x, y + (36 * Scale.height), text, font
    UI\add t

  createMainMenu: =>
    UI\set_screen Screen_State.main_menu

    @createHelp!

    title = Text Screen_Size.width / 2, (Screen_Size.height / 4), "Tower Defense"
    UI\add title

    start_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) - (32 * Scale.height), 250, 60, "Start", () ->
      Driver.game_state = Game_State.playing
      UI\set_screen Screen_State.none
    UI\add start_button

    exit_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + (32 * Scale.height), 250, 60, "Exit", () -> love.event.quit 0
    UI\add exit_button

  createPauseMenu: =>
    UI\set_screen Screen_State.pause_menu

    @createHelp nil, Screen_Size.height * 0.2

    title = Text Screen_Size.width / 2, (Screen_Size.height / 3), "Game Paused"
    UI\add title

    names = {"Basic", "Chaser", "Spawner", "Strong", "Turret"}
    sprites = {(Sprite "enemy/tracker.tga", 32, 32, 1, 50 / 32), (Sprite "enemy/enemy.tga", 26, 26, 1, 50 / 26), (Sprite "projectile/dart.tga", 17, 17, 1, 50 / 17), (Sprite "enemy/bullet.tga", 26, 20, 1, 50 / 26), (Sprite "enemy/circle.tga", 26, 26, 1, 50 / 26)}

    for i = 1, #names
      x = map i, 1, #names, 100 * Scale.width, Screen_Size.width - (200 * Scale.width)
      y = Screen_Size.height * 0.8
      icon = Icon x, y, sprites[i]
      UI\add icon
      bounds = sprites[i]\getBounds x, y
      font = Renderer\newFont 20
      width = font\getWidth names[i]
      text = Text x + (10 * Scale.width) + bounds.radius + (width / 2), y, names[i], font
      UI\add text

    sprite = Sprite "test.tga", 16, 16, 0.29, 50 / 16
    sprite\setRotationSpeed -math.pi / 2
    x = Screen_Size.width * 0.20
    y = Screen_Size.height * 0.4
    icon = Icon x, y, sprite
    UI\add icon
    bounds = sprite\getBounds x, y
    font = Renderer\newFont 20
    width = font\getWidth "Player"
    text = Text x + (10 * Scale.width) + bounds.radius + (width / 2), y, "Player", font
    UI\add text

    sprite = Sprite "turret.tga", 34, 16, 2, 50 / 34
    x = Screen_Size.width * 0.80
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

    restart_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + (38 * Scale.height), 250, 60, "Restart", () -> Driver.restart!
    UI\add restart_button

    quit_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + (108 * Scale.height), 250, 60, "Quit", () -> love.event.quit 0
    UI\add quit_button

  createGameOverMenu: =>
    UI\set_screen Screen_State.game_over

    title = Text Screen_Size.width / 2, (Screen_Size.height / 2), "YOU LOSE!", Renderer.giant_font
    UI\add title

    restart_button = Button Screen_Size.width / 2, Screen_Size.height - (200 * Scale.height), 250, 60, "Restart", () -> Driver.restart!
    UI\add restart_button

    quit_button = Button Screen_Size.width / 2, Screen_Size.height - (130 * Scale.height), 250, 60, "Quit", () -> love.event.quit 0
    UI\add quit_button

  createUpgradeMenu: =>
    UI\set_screen Screen_State.upgrade

    bg = Background {255, 255, 255, 255}--{8, 167, 0, 255}
    UI\add bg

    title = Text Screen_Size.width / 2, 25 * Scale.height, "Upgrade"
    UI\add title

    names = {"Player", "Turret"}
    stats = {{"Health", "Range", "Damage", "Speed", "Attack Delay", "Special"}, {"Health", "Range", "Damage", "Cooldown", "Attack Delay", "Special"}}
    num_stats = 6
    trees = {Upgrade_Trees.player_stats, Upgrade_Trees.turret_stats, Upgrade_Trees.player_special, Upgrade_Trees.turret_special}
    specials = {{"Life Steal", "Range Boost", "Bomb", "Speed Boost"}, {"Extra Turret", "Shield", "Multiple Targets", "Pickup"}}
    num_specials = 4
    descriptions = {{"Recover life from hit enemies", "Double player range near turret", "An instant kill bomb drops randomly", "Player speed increases for every enemy near them"}, {"Use 'E' to place another turret", "Allies receive a temporary shield when a turret gets to half health", "Turret can hit more than a single enemy", "Use 'E' to pickup turrets after they have been placed"}}
    width = 0
    font = Renderer\newFont 15

    for k, v in pairs specials
      for k2, v2 in pairs v
        w = font\getWidth v2
        if w >= width
          width = w

    for i = 1, 2
      mod = i - 1
      UI\add Text (90 - (5 * mod)) * Scale.width, (65 + (420 * mod)) * Scale.height, names[i], Renderer.hud_font

      for j = 1, num_stats
        y = (25 + (j * 65) + (425 * mod)) * Scale.height
        UI\add Text 190 * Scale.width, y, stats[i][j], Renderer.small_font
        if j ~= num_stats
          stats_table = Upgrade.player_stats
          current_stats = Stats.player
          if i == 2
            stats_table = Upgrade.turret_stats
            current_stats = Stats.turret
          tt = Tooltip Screen_Size.width * (5 / 24), y - (30 * Scale.height), (() =>
            level = stats_table[j]
            if level == Upgrade.max_skill
              return "Upgrade Complete!"
            else
              modifier = 0
              if level > 0
                modifier = Upgrade.amount[i][j][level]
              amount = Upgrade.amount[i][j][level + 1] - modifier
              amount /= current_stats[j]
              amount *= 100
              message = "  " .. names[i] .. "  " .. stats[i][j] .. "  by  " .. (string.format "%d", math.floor math.abs amount) .. "%"
              if amount < 0
                message = "Decrease" .. message
              else
                message = "Increase" .. message
              return message
          ), font
          tt2 = Tooltip Screen_Size.width * 0.72, y, (() =>
            level = stats_table[j]
            if level == Upgrade.max_skill
              return ""
            else
              modifier = 0
              if level > 0
                modifier = Upgrade.amount[i][j][level]
              amount = Upgrade.amount[i][j][level + 1] - modifier
              message = "("
              if amount < 0
                message ..= "-"
              else
                message ..= "+"
              message ..= (string.format "%.3f", math.abs amount) .. ")"
              return message
          ), Renderer.hud_font, "right"
          tt2.color = {0, 225, 0, 255}
          tt3 = Tooltip Screen_Size.width * 0.95, 17.5 * Scale.height, (() =>
            level = stats_table[j] + 1
            if level <= Upgrade.max_skill
              return "-" .. Upgrade.upgrade_cost[level]
            else
              return ""
          ), Renderer.hud_font
          tt3.color = {225, 0, 0, 255}
          b = TooltipButton 280 * Scale.width, y, 30, 30, "+", (() ->
            Upgrade\add_skill trees[i], j
          ), nil, {tt, tt2, tt3}
          UI\add b
          UI\add tt
          UI\add tt2
          UI\add tt3
        else
          x = (280 + (width / 2)) * Scale.width
          for k = 1, num_specials
            special_table = Upgrade.player_special
            if i == 2
              special_table = Upgrade.turret_special
            tt = Tooltip 280 * Scale.width, y - (30 * Scale.height), (() =>
              return descriptions[i][k]
            ), font
            tt2 = Tooltip Screen_Size.width * 0.95, 17.5 * Scale.height, (() =>
              if special_table[k]
                return ""
              else
                return "-5"
            ), Renderer.hud_font
            tt2.color = {225, 0, 0, 255}
            b = TooltipButton x, y, width + 10, 30, specials[i][k], (() =>
              result = Upgrade\add_skill trees[2 + i], k
              @active = not result
            ), font, {tt, tt2}
            x += b.width + (10 * Scale.width)
            UI\add b
            UI\add tt
            UI\add tt2

    continue_button = Button Screen_Size.width - 150, Screen_Size.height - (32 * Scale.height), 200, 45, "Continue", () ->
      UI\set_screen Screen_State.none
      Driver.game_state = Game_State.playing
      Driver\respawnPlayers!
      Objectives\nextMode!
    UI\add continue_button
