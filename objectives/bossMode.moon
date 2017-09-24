export class BossMode extends Mode
  new: (parent) =>
    super parent
    @objective_text = "Eliminate the boss"
    @mode_type = ModeTypes.boss
    @bosses = {
      --BossVyder
      BossTest
    }

  nextWave: =>
    super!
    boss = pick @bosses
    @wave = BossWave @, boss

  finish: =>
    super!
    Objectives.bosses_beaten += 1

  update: (dt) =>
    if not @complete
      if not @started
        @start!
      if not @wave.complete
        @wave\update dt
        level = Objectives\getLevel! + 1
        @message2 = "Level " .. level
        if @wave.complete
          @wave\finish!
      else
        @parent.difficulty += 2
        @complete = true
        @started = false
