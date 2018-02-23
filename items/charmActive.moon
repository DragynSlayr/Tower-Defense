export class CharmActive extends ActiveItem
  @lowest_rarity = 3
  new: (rarity) =>
    @rarity = rarity
    cd = ({24, 22, 20, 18, 16})[@rarity]
    sprite = Sprite "item/charmActive.tga", 32, 32, 3, 1.75
    effect = (player) =>
      for k, v in pairs Driver.objects[EntityTypes.enemy]
        if #v.attack_filters > 0 and math.random! > (1 - @effect_chance)
          v.charmed = true
          v.old_attack_filters = v.attack_filters
          v.attack_filters = {EntityTypes.boss, EntityTypes.enemy}
          --v.old_solid = v.solid
          --v.solid = false
          v.old_damage = v.damage
          v.damage = v.damage * 2
    super sprite, cd, effect
    @name = "Charming Heart"
    @description = "Charms enemies"
    @effect_time = ({10, 11, 12, 13, 14})[@rarity]
    @effect_chance = 1
    @onEnd = () =>
      for k, v in pairs Driver.objects[EntityTypes.enemy]
        if v.charmed
          v.charmed = false
          v.attack_filters = v.old_attack_filters
          v.old_attack_filters = nil
          --v.solid = v.old_solid
          --v.old_solid = nil
          v.damage = v.old_damage
          v.old_damage = nil

  getStats: =>
    stats = super!
    table.insert stats, "Duration: " .. @effect_time .. "s"
    return stats
