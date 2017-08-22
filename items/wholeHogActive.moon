export class WholeHogActive extends ActiveItem
  new: (x, y) =>
    @rarity = @getRandomRarity!
    cd = ({20, 19, 18, 17, 16})[@rarity]
    sprite = Sprite "item/wholeHogActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      @player.knocking_back = true
      @used = true
    super x, y, sprite, cd, effect
    @name = "Whole Hog"
    @description = "Player bullets do knockback"
    @used = false
    @effect_time = ({10, 11, 12, 13, 14})[@rarity]
    @effect_timer = 0

  getStats: =>
    stats = super!
    table.insert stats, "Duration: " .. @effect_time .. "s"
    return stats

  update2: (dt) =>
    super dt
    if @used
      @effect_timer += dt
      if @effect_timer >= @effect_time
        @effect_timer = 0
        @used = false
        @player.knocking_back = false
