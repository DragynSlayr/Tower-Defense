export class PassiveItem extends Item
  new: (x, y, sprite, delay = -1, effect) =>
    super x, y, sprite
    @item_type = ItemTypes.passive
    @effect = effect
    @delay = delay
    
  pickup: (player) =>
    super player
    if @delay == -1
      @effect @player

  update2: (dt) =>
    super dt
    if @delay ~= -1 and @timer >= @delay
      @timer = 0
      @effect @player
