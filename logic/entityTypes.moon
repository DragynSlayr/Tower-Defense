export class EntityTypes
  new: =>
    @player = "Player"
    @turret = "Turret"
    @enemy  = "Enemy"
    @item   = "Item"
    @health = "Health"
    @coin   = "Coin"

    @layers = {}
    @layers[@player] = 4
    @layers[@turret] = 1
    @layers[@enemy]  = 3
    @layers[@item]   = 2
    @layers[@health] = 2
    @layers[@coin]   = 2
