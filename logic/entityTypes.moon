export class EntityTypes
  new: =>
    @player = "Player"
    @turret = "Turret"
    @enemy  = "Enemy"
    @item   = "Item"
    @health = "Health"
    @coin   = "Coin"
    @bullet = "Bullet"

    @layers = {}
    @layers[@player] = 5
    @layers[@turret] = 2
    @layers[@enemy]  = 4
    @layers[@item]   = 3
    @layers[@health] = 3
    @layers[@coin]   = 3
    @layers[@bullet] = 1
