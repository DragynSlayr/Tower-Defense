export class BossWave extends Wave
  new: (parent, boss) =>
    super parent
    @boss = boss

  entityKilled: (entity) =>
    if entity == @boss
      @complete = true
      if @boss.trail
        Driver\removeObject @boss.trail, false
      if @boss.shader
        Objectives.shader = @old_shader

  start: =>
    @boss = Objectives\spawn (@boss), EntityTypes.boss
    if @boss.trail
      Driver\addObject @boss.trail, EntityTypes.particle
    if @boss.shader
      @old_shader = Objectives.shader
      Objectives.shader = @boss.shader

  draw: =>
    @parent.message1 = "\t" .. "BOSS BATTLE!!"
    super!
