export class ItemBoxPickUp extends BackgroundObject
  new: (x, y) =>
    sprite = Sprite "item/box.tga", 32, 32, 1, 1.75
    super x, y, sprite

  update: (dt) =>
    super dt
    if Driver.objects[EntityTypes.player]
      for k, p in pairs Driver.objects[EntityTypes.player]
        player = p\getHitBox!
        box = @getHitBox!
        if player\contains box
          Inventory.boxes += 1
          @health = 0
