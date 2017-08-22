export class ActiveItem extends Item
  new: (x, y, sprite, charge_time = 0, effect) =>
    super x, y, sprite
    @item_type = ItemTypes.active
    @charged = true
    @charge_time = charge_time
    @effect = effect

    @sprite\setShader love.graphics.newShader "shaders/active_item_shader.fs"

  getStats: =>
    stats = super!
    table.insert stats, "Cooldown: " .. @charge_time .. "s"
    return stats

  use: =>
    if @charged
      @timer = 0
      @charged = false
      @effect @player
    else
      print "On Cooldown: " .. math.floor (@charge_time - @timer)

  draw2: =>
    love.graphics.push "all"

    x = ((Screen_Size.width / 2) + (10 * Scale.width)) / 2
    y = Screen_Size.height - (35 * Scale.height)

    if @charged
      love.graphics.setColor 132, 87, 15, 200
    else
      love.graphics.setColor 15, 87, 132, 200
    love.graphics.rectangle "fill", x - (60 * Scale.width * 0.5), y - (60 * Scale.height * 0.5), 60 * Scale.width, 60 * Scale.height

    @sprite\draw x, y

    if not @charged
      love.graphics.setColor 0, 0, 0, 127
      font = Renderer.hud_font
      love.graphics.setFont font
      message = math.ceil (@charge_time - @timer)
      love.graphics.printf message, x + (60 * Scale.width * 0.5), y - (font\getHeight! / 2), 60 * Scale.width, "center"

    love.graphics.pop!

  update2: (dt) =>
    super dt
    if not @charged and @timer >= @charge_time
      @timer = 0
      @charged = true
    amount = 0
    if not @charged
      amount = 1 - (@timer / @charge_time)
    @sprite.shader\send "amount", amount
