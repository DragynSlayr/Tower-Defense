export class WholeHogActive extends ActiveItem
  new: (x, y) =>
    sprite = Sprite "item/wholeHogActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      @player.knocking_back = true
      @used = true
    super x, y, sprite, 20, effect
    @name = "Whole Hog"
    @description = "Player bullets do knockback"
    @used = false
    @effect_time = 10
    @effect_timer = 0

  update2: (dt) =>
    super dt
    if @used
      @effect_timer += dt
      if @effect_timer >= @effect_time
        @effect_timer = 0
        @used = false
        @player.knocking_back = false
