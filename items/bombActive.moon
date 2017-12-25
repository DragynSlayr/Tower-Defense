export class BombActive extends ActiveItem
  new: =>
    @rarity = @getRandomRarity!
    cd = ({15, 12.5, 10, 7.5, 5})[@rarity]
    sprite = Sprite "background/bomb.tga", 32, 32, 1, 1.75
    effect = (player) =>
      bomb = Bomb player.position.x, player.position.y
      Driver\addObject bomb, EntityTypes.background
    super sprite, cd, effect
    @name = "Bomb"
    @description = "Places a powerful bomb"
    @effect_time = 3
