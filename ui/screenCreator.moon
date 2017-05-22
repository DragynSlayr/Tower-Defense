export class ScreenCreator
  new: =>
    @createMainMenu!
    @createPauseMenu!
    @createGameOverMenu!

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

    title = Text Screen_Size.width / 2, (Screen_Size.height / 2), "YOU DIED!", Renderer.giant_font
    UI\add title

    restart_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + 50, 250, 60, "Restart", () ->
      Driver.unpause!
    --UI\add resume_button

    quit_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + 170, 250, 60, "Quit", () -> love.event.quit 0
    UI\add quit_button
