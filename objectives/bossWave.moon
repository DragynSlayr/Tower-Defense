export class BossWave extends Wave
  new: (parent, boss) =>
    super parent
    @boss = boss

  entityKilled: (entity) =>
    if entity.id == @boss.id
      @complete = true

  start: =>
    Objectives\spawn @boss

  draw: =>
    @parent.message1 = "\t" .. "BOSS BATTLE!!"
    super!
