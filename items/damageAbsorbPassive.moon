export class DamageAbsorbPassive extends PassiveItem
  new: (x, y) =>
    sprite = Sprite "item/damageAbsorbPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      health = player.health
      if health < @last_health
        difference = @last_health - health
        @last_health = health
        if math.random! >= 0.95
          player.health += player.max_health * 0.10
    super x, y, sprite, 0, effect
    @name = "Damage Absorb"
    @description = "Has a chance to absorb incoming damage"

  pickup: (player) =>
    super player
    @last_health = player.health
