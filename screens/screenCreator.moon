export class ScreenCreator
  new: =>
    @createMainMenu!
    @createPauseMenu!
    @createGameOverMenu!
    @createUpgradeMenu!

  createMainMenu: =>
    UI\set_screen Screen_State.main_menu

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

    title = Text Screen_Size.width / 2, (Screen_Size.height / 3), "Game Paused"
    UI\add title

    names = {"Basic", "Player", "Spawner", "Strong", "Turret"}
    sprites = {(Sprite "enemy/tracker.tga", 32, 32, 1, 1.25), (Sprite "enemy/enemy.tga", 26, 26, 1, 0.75), (Sprite "projectile/dart.tga", 17, 17, 1, 2), (Sprite "enemy/bullet.tga", 26, 20, 1, 2), (Sprite "enemy/circle.tga", 26, 26, 1, 1.75)}

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

    resume_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) - (32 * Scale.height), 250, 60, "Resume", () ->
      Driver.unpause!
    UI\add resume_button

  createGameOverMenu: =>
    UI\set_screen Screen_State.game_over

    title = Text Screen_Size.width / 2, (Screen_Size.height / 2), "YOU LOSE!", Renderer.giant_font
    UI\add title

    restart_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + (50 * Scale.height), 250, 60, "Restart", () ->
      Driver.unpause!
    --UI\add resume_button

    quit_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + (170 * Scale.height), 250, 60, "Quit", () -> love.event.quit 0
    UI\add quit_button

  createUpgradeMenu: =>
    UI\set_screen Screen_State.upgrade

    bg = Background {255, 255, 255, 255}--{8, 167, 0, 255}
    UI\add bg

    title = Text Screen_Size.width / 2, 25 * Scale.height, "Upgrade"
    UI\add title

    UI\add Text 100 * Scale.width, 100 * Scale.width, "Player", Renderer.hud_font
    stats = {"Health", "Range", "Damage", "Speed", "Special"}

    for k, v in pairs stats
      y = (100 + (k * 65)) * Scale.height
      UI\add Text 200 * Scale.width, y, v, Renderer.small_font
      if k ~= 5
        --message = "  Player  " .. v .. "  by  " .. math.abs Upgrade.amount[1][k]
        --if Upgrade.amount[1][k] < 0
        --  message = "Decrease" .. message
        --else
        --  message = "Increase" .. message
        --tt = Tooltip 400, y - 30, message, Renderer\newFont 15
        --m2 = "("
        --if Upgrade.amount[1][k] < 0
        --  m2 ..= "-"
        --else
        --  m2 ..= "+"
        --tt2 = Tooltip Screen_Size.width * 0.9, y, m2 .. math.abs(Upgrade.amount[1][k]) .. ")", Renderer\newFont 30
        --tt2.color = {0, 225, 0, 255}
        b = TooltipButton 280 * Scale.width, y, 30, 30, "+", (() -> Upgrade\add_skill Upgrade_Trees.player_stats, k), nil, {tt, tt2}
        UI\add b
        --UI\add tt
        --UI\add tt2
      else
        specials = {"1", "2", "3", "4"}
        for k, v in pairs specials
          x = (280 + ((k - 1) * 100)) * Scale.width
          b = Button x, y, 50, 30, v, () -> Upgrade\add_skill Upgrade_Trees.player_special, k
          --b\autoResize 50, 30
          UI\add b

    UI\add Text 100 * Scale.width, 500 * Scale.height, "Turret", Renderer.hud_font
    stats = {"Health", "Range", "Damage", "Cooldown", "Special"}

    for k, v in pairs stats
      y = (500 + (k * 65)) * Scale.height
      UI\add Text 200 * Scale.width, y, v, Renderer.small_font
      if k ~= 5
        --message = "  Turret  " .. v .. "  by  " .. math.abs Upgrade.amount[2][k]
        --if Upgrade.amount[2][k] < 0
        --  message = "Decrease" .. message
        --else
        --  message = "Increase" .. message
        --tt = Tooltip 400, y - 30, message, Renderer\newFont 15
        --m2 = "("
        --if Upgrade.amount[2][k] < 0
        --  m2 ..= "-"
        --else
        --  m2 ..= "+"
        --tt2 = Tooltip Screen_Size.width * 0.9, y, m2 .. math.abs(Upgrade.amount[2][k]) .. ")", Renderer\newFont 30
        --tt2.color = {0, 225, 0, 255}
        b = TooltipButton 280 * Scale.width, y, 30, 30, "+", (() -> Upgrade\add_skill Upgrade_Trees.turret_stats, k), nil, {tt, tt2}
        UI\add b
        --UI\add tt
        --UI\add tt2
      else
        specials = {"1", "2", "3", "4"}
        for k, v in pairs specials
          x = (280 + ((k - 1) * 100)) * Scale.width
          b = Button x, y, 50, 30, v, () -> Upgrade\add_skill Upgrade_Trees.turret_special, k
          --b\autoResize 50, 30
          UI\add b

    continue_button = Button Screen_Size.width / 2, Screen_Size.height - (35 * Scale.height), 200, 50, "Continue", () ->
      UI\set_screen Screen_State.none
      Driver.game_state = Game_State.playing
      Driver\respawnPlayers!
      Objectives\nextMode!
    UI\add continue_button
