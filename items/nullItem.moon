export class NullItem extends Item
  @probability = 0
  new: (x, y) =>
    sprite = Sprite "item/empty.tga", 32, 32, 1, 1.75
    super x, y, sprite
    @name = "Empty"
    @description = "No item in this slot"

  getCopy: =>
    item = NullItem @position.x, @position.y
    item.name = @name
    item.description = @description
    item.sprite = Sprite "item/empty.tga", 32, 32, 1, 1.75
    return item
