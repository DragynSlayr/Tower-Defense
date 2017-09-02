export class BlackHoleActive extends ActiveItem
  new: (x, y) =>
    @rarity = @getRandomRarity!
    cd = ({20, 18, 16, 14, 12})[@rarity]
    sprite = Sprite "background/blackhole.tga", 32, 32, 1, 1.75
    effect = (player) =>
      hole = BlackHole player.position.x, player.position.y
      Driver\addObject hole, EntityTypes.background
    super x, y, sprite, cd, effect
    @name = "Singularity"
    @description = "Places a black hole that sucks in enemies"
    @effect_time = 7.5
