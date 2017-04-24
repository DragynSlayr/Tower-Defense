export class Player extends GameObject
  new: (x, y, sprite) =>
    super x, y, sprite
    @position = Vector love.graphics.getWidth! / 2, love.graphics.getHeight! / 2
    @max_speed = 275

  keypressed: (key) =>
    @key = key
    @speed.x, @speed.y = switch key
      when "w"
        0, -@max_speed
      when "a"
        -@max_speed, 0
      when "s"
        0, @max_speed
      when "d"
        @max_speed, 0
      else
        @speed.x, @speed.y

  keyreleased: (key) =>
    @key = key
    if key == "d" or key == "a"
      @speed.x = 0
    elseif key == "w" or key == "s"
      @speed.y = 0
