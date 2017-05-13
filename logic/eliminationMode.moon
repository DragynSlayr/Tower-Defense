export class EliminationMode extends Mode
  new: (parent) =>
    super parent

  nextWave: =>
    super!
    num = (((@level_count - 1) * 3) + @wave_count) * 3
    @wave = EliminationWave @, num + 5
