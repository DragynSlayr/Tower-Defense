export class DefendMode extends Mode
  new: (parent) =>
    super parent
    @objective_text = "Protect the objective"

  nextWave: =>
    super!
    @wave = DefendWave @

  finish: =>
    super!
    if Driver.objects[EntityTypes.goal]
      for k, o in pairs Driver.objects[EntityTypes.goal]
        Driver\removeObject o, false
