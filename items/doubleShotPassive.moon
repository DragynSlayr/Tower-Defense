export class DoubleShotPassive extends PassiveItem
  new: =>
    @rarity = @getRandomRarity!
    @damage_multiplier = ({0.5, 0.6, 0.7, 0.8, 0.9})[@rarity]
    sprite = Sprite "item/doubleShotPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      filters = {EntityTypes.enemy, EntityTypes.boss}
      for k2, typeof in pairs filters
        if Driver.objects[typeof]
          for k, v in pairs Driver.objects[typeof]
            enemy = v\getHitBox!
            p = player\getHitBox!
            p.radius += player.attack_range + player.range_boost
            if p\contains enemy
              bullet = PlayerBullet player.position.x, player.position.y, v, player.damage * @damage_multiplier
              bullet.sprite = Sprite "projectile/doubleShot.tga", 26, 20, 1, 0.5
              Driver\addObject bullet, EntityTypes.bullet
    super sprite, 0, effect
    @name = "Double Shot"
    @description = "Shoot an extra bullet"

  getStats: =>
    stats = super!
    table.insert stats, "Damage Multiplier: " .. @damage_multiplier
    return stats

  pickup: (player) =>
    super player
    @delay = player.attack_speed
