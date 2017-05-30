export class DarkMode extends Mode
  new: (parent) =>
    super parent
    @objective_text = "Find the locked hearts"

  nextWave: =>
    super!
    @wave = DarkWave @
