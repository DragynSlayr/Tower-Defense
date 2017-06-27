export class BossMode extends Mode
  new: (parent) =>
    super parent
    @objective_text = "Eliminate the boss"
    @mode_type = ModeTypes.boss
    @bosses = {}
    i = 1
    for k, v in pairs BossTypes
      @bosses[i] = v
      i += 1

  nextWave: =>
    super!
    boss = pick @bosses
    @wave = BossWave @, boss

  update: (dt) =>
    if not @complete
      if not @started
        @start!
      if not @wave.complete
        @wave\update dt
        level = @parent\getLevel! + 1
        @message2 = "Level " .. level
        if @wave.complete
          @wave\finish!
      else
        @parent.difficulty += 2
        @complete = true
        @started = false
