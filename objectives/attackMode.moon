export class AttackMode extends Mode
  new: (parent) =>
    super parent
    @objective_text = "Destroy the objectives"
    @mode_type = ModeTypes.attack

  nextWave: =>
    super!
    @wave = AttackWave @
