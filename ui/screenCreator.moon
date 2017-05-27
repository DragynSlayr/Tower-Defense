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

    start_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) - 32, 250, 60, "Start", () ->
      Driver.game_state = Game_State.playing
      UI\set_screen Screen_State.none
    UI\add start_button

    exit_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + 32, 250, 60, "Exit", () -> love.event.quit 0
    UI\add exit_button

  createPauseMenu: =>
    UI\set_screen Screen_State.pause_menu

    title = Text Screen_Size.width / 2, (Screen_Size.height / 3), "Game Paused"
    UI\add title

    resume_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) - 32, 250, 60, "Resume", () ->
      Driver.unpause!
    UI\add resume_button

  createGameOverMenu: =>
    UI\set_screen Screen_State.game_over

    title = Text Screen_Size.width / 2, (Screen_Size.height / 2), "YOU LOSE!", Renderer.giant_font
    UI\add title

    restart_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + 50, 250, 60, "Restart", () ->
      Driver.unpause!
    --UI\add resume_button

    quit_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + 170, 250, 60, "Quit", () -> love.event.quit 0
    UI\add quit_button

  createUpgradeMenu: =>
    UI\set_screen Screen_State.upgrade

    bg = Background {255, 255, 255, 255}--{8, 167, 0, 255}
    UI\add bg

    title = Text Screen_Size.width / 2, 25, "Upgrade"
    UI\add title

    UI\add Text 100, 100, "Player", Renderer.hud_font
    stats = {"Health", "Range", "Damage", "Speed", "Special"}

    for k, v in pairs stats
      y = 100 + (k * 65)
      UI\add Text 200, y, v, Renderer.small_font
      if k ~= 5
        tt = Tooltip 400, y - 30, "Increase  Player  " .. v .. "  by  " .. Upgrade.amount[1][k], Renderer\newFont 15
        tt2 = Tooltip Screen_Size.width * 0.9, y, "(+" .. math.abs(Upgrade.amount[1][k]) .. ")", Renderer\newFont 30
        tt2.color = {0, 225, 0, 255}
        b = TooltipButton 280, y, 30, 30, "+", (() -> Upgrade\add_skill Upgrade_Trees.player_stats, k), nil, {tt, tt2}
        UI\add b
        UI\add tt
        UI\add tt2
      else
        specials = {"1", "2", "3", "4"}
        for k, v in pairs specials
          x = 280 + ((k - 1) * 100)
          b = Button x, y, 50, 30, v, () -> Upgrade\add_skill Upgrade_Trees.player_special, k
          UI\add b

    UI\add Text 100, 500, "Turret", Renderer.hud_font
    stats = {"Health", "Range", "Damage", "Cooldown", "Special"}

    for k, v in pairs stats
      y = 500 + (k * 65)
      UI\add Text 200, y, v, Renderer.small_font
      if k ~= 5
        tt = Tooltip 400, y - 30, "Increase  Turret  " .. v .. "  by  " .. Upgrade.amount[2][k], Renderer\newFont 15
        tt2 = Tooltip Screen_Size.width * 0.9, y, "(+" .. math.abs(Upgrade.amount[2][k]) .. ")", Renderer\newFont 30
        tt2.color = {0, 225, 0, 255}
        b = TooltipButton 280, y, 30, 30, "+", (() -> Upgrade\add_skill Upgrade_Trees.turret_stats, k), nil, {tt, tt2}
        UI\add b
        UI\add tt
        UI\add tt2
      else
        specials = {"1", "2", "3", "4"}
        for k, v in pairs specials
          x = 280 + ((k - 1) * 100)
          b = Button x, y, 50, 30, v, () -> Upgrade\add_skill Upgrade_Trees.turret_special, k
          UI\add b

    continue_button = Button Screen_Size.width / 2, Screen_Size.height - 35, 200, 50, "Continue", () ->
      UI\set_screen Screen_State.none
      Driver.game_state = Game_State.playing
      Objectives\nextMode!
    UI\add continue_button
