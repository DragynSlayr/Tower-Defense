export class DamageAbsorbPassive extends PassiveItem
  new: (x, y) =>
    @rarity = @getRandomRarity!
    @chance = ({5, 7.5, 10, 12.5, 15})[@rarity]
    sprite = Sprite "item/damageAbsorbPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      health = player.health
      if health < @last_health
        difference = @last_health - health
        @last_health = health
        if math.random! >= ((100 - @chance) / 100)
          player.health += player.max_health * 0.10
    super x, y, sprite, 0, effect
    @name = "Damage Absorb"
    @description = "Has a chance to absorb incoming damage"

  getStats: =>
    stats = super!
    table.insert stats, "Absorb Chance: " .. @chance .. "%"
    return stats

  pickup: (player) =>
    super player
    @last_health = player.health
