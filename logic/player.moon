export class Player extends GameObject
  new: (x, y, sprite) =>
    super x, y, sprite
    @max_speed = 275
    @max_turrets = 1
    @num_turrets = 0
    @turret = {}

  keypressed: (key) =>
    @last_pressed = key
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
    if key == "q"
      x = math.random love.graphics.getWidth!
      y = math.random love.graphics.getHeight!
      enemy = BasicEnemy x, y
      Driver\addObject enemy, EntityTypes.enemy
    if key == "space"
      if @show_turret
        turret = BasicTurret @position.x, @position.y
        if turret\isOnScreen! and @num_turrets < @max_turrets
          Driver\addObject turret, EntityTypes.turret
          @num_turrets += 1
          @turret[#@turret + 1] = turret
          @show_turret = false
      else
        if @num_turrets != @max_turrets
          @show_turret = true

  keyreleased: (key) =>
    @last_released = key
    if key == "d" or key == "a"
      @speed.x = 0
    elseif key == "w" or key == "s"
      @speed.y = 0

  update: (dt) =>
    super dt
    if @show_turret
      turret = BasicTurret @position.x, @position.y
      Renderer\enqueue turret\drawFaded
