export class ItemBox extends Item
  new: (x, y) =>
    sprite = Sprite "item/box.tga", 32, 32, 1, 1.75
    super x, y, sprite
    @name = "Item Box"
    @description = "Open to get a random item"

  pickup: (player) =>
    @collectable = false
    @contact_damage = false
    @solid = false
    Inventory.boxes += 1
