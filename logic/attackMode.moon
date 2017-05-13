export class AttackMode extends Mode
  new: (parent) =>
    super parent

  nextWave: =>
    super!
    @wave = AttackWave @
