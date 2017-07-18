export class DamageReflectPassive extends PassiveItem
  new: (x, y) =>
    sprite = Sprite "item/damageReflectPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      health = player.health
      if health < @last_health
        difference = @last_health - health
        @last_health = health
        if math.random! >= 0.5
          filters = {EntityTypes.enemy, EntityTypes.player}
          for k2, typeof in pairs filters
            if Driver.objects[typeof]
              for k, e in pairs Driver.objects[typeof]
                enemy = e\getHitBox!
                p = player\getHitBox!
                p.radius += player.attack_range + player.range_boost
                if p\contains enemy
                  temp_damage = player.damage
                  player.damage = difference
                  e\onCollide player
                  player.damage = temp_damage
    super x, y, sprite, 0, effect
    @name = "Damage Reflect"
    @description = "Has a chance to reflect damage taken"

  pickup: (player) =>
    super player
    @last_health = player.health
