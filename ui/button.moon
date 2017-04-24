export class Button
  new: (x, y, width, height, text, action) =>
    @x = x
    @y = y
    @width = width
    @height = height
    @text = text
    @action = action
    @idle_color = {175, 175, 175}
    @hover_color = {100, 100, 100}
    @selected = false

  setColor: (idle, hover) =>
    @idle_color = idle
    @hover_color = hover

  setSprite: (idle, hover) =>
    @idle_sprite = idle
    @hover_sprite = hover
    @sprited = true

  draw: =>
    love.graphics.push "all"
    if @sprited
      if @selected
        @hover_sprite\draw @x, @y
      else
        @idle_sprite\draw @x, @y
    else
      if @selected
        love.graphics.setColor @hover_color[1], @hover_color[2], @hover_color[3], @hover_color[4]
      else
        love.graphics.setColor @idle_color[1], @idle_color[2], @idle_color[3], @idle_color[4]
      love.graphics.rectangle "fill", @x, @y, @width, @height
    love.graphics.setColor 0, 0, 0
    love.graphics.printf @text, @x, @y + ((@height - love.graphics.getFont\getHeight!) / 2), @width, "center"
    love.graphics.pop!

  update: (dt) =>
    x, y = love.mouse.getPosition!
    @selected = @isHovering x, y
    if @selected and love.mouse.isDown 1
      @action!

    if @sprited
      @idle_sprite\update dt
      @hover_sprite\update dt

  isHovering: (x, y) =>
    xOn = @x <= x and @x + @width >= x
    yOn = @y <= y and @y + @height >= y
    return xOn and yOn
