export class Boss extends GameObject
  new: (x, y, sprite) =>
    super x, y, sprite
    @item_drop_chance = 0.75
    @colliders = {EntityTypes.player, EntityTypes.turret}

    @bossType = nil
    @contact_damage = true
    @solid = false
