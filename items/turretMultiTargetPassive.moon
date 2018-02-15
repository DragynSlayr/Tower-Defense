export class TurretMultiTargetPassive extends PassiveItem
  @lowest_rarity = 5
  new: (rarity) =>
    @rarity = rarity
    sprite = Sprite "item/turretMultiTargetPassive.tga", 32, 32, 1, 1.75
    @old_num = 0
    effect = (player) =>
      if @old_num < player.num_turrets
        for k, t in pairs player.turret
          t.multitarget = true
      @old_num = player.num_turrets
    super sprite, 0, effect
    @name = "Multi Target"
    @description = "Turret can target multiple enemies"
