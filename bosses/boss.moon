export class Boss extends GameObject
  new: (x, y, sprite) =>
    super x, y, sprite
    @bossType = nil
    @item_drop_chance = 0.75
