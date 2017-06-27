export class BossWave extends Wave
  new: (parent, boss) =>
    super parent
    @boss = boss

  entityKilled: (entity) =>
    if entity == @boss
      @complete = true

  start: =>
    @boss = Objectives\spawn @boss

  draw: =>
    @parent.message1 = "\t" .. "BOSS BATTLE!!"
    super!
