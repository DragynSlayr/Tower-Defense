export class BossWave extends Wave
  new: (parent, boss) =>
    super parent
    @boss = boss

  entityKilled: (entity) =>
    if entity == @boss
      @complete = true
      if @boss.trail
        Driver\removeObject @boss.trail, false

  start: =>
    @boss = Objectives\spawn (@boss), EntityTypes.boss
    if @boss.trail
      Driver\addObject @boss.trail, EntityTypes.particle

  draw: =>
    @parent.message1 = "\t" .. "BOSS BATTLE!!"
    super!
