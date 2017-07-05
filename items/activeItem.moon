export class ActiveItem extends Item
  new: (x, y, sprite, charge_time = 0, effect) =>
    super x, y, sprite
    @item_type = ItemTypes.active
    @charged = true
    @charge_time = charge_time
    @effect = effect

  use: =>
    if @charged
      @timer = 0
      @charged = false
      @effect @player
    else
      print "On Cooldown: " .. math.floor (@charge_time - @timer)

  draw2: =>
    love.graphics.push "all"
    love.graphics.setColor 0, 0, 0, 255
    message = "Ready"
    if not @charged
      message = math.ceil (@charge_time - @timer)
    Renderer\drawHUDMessage message, Screen_Size.width * 0.2, Screen_Size.height - (50 * Scale.height), Renderer.hud_font
    love.graphics.pop!

  update2: (dt) =>
    super dt
    if not @charged and @timer >= @charge_time
      @timer = 0
      @charged = true
