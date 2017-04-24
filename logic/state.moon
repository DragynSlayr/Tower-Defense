export class State
  new: =>
    @menu_state = 1
    @paused_state = 2
    @playing_state = 3
    @game_over_state = 4

    @current_state = @menu_state
