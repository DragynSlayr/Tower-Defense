export class CaptureMode extends Mode
  new: (parent) =>
    super parent
    @objective_text = "Capture the objective"
    @mode_type = ModeTypes.capture

  nextWave: =>
    super!
    @wave = CaptureWave @

  finish: =>
    super!
    if Driver.objects[EntityTypes.goal]
      for k, o in pairs Driver.objects[EntityTypes.goal]
        Driver\removeObject o, false
