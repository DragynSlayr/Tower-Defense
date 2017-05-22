export class AttackMode extends Mode
  new: (parent) =>
    super parent
    @objective_text = "Destroy the objectives"

  nextWave: =>
    super!
    @wave = AttackWave @
