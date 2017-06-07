export class DarkMode extends Mode
  new: (parent) =>
    super parent
    @objective_text = "Find the locked hearts"
    @mode_type = ModeTypes.dark

  nextWave: =>
    super!
    @wave = DarkWave @
