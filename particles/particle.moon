export class Particle extends GameObject
  new: (x, y, sprite, alpha_start = 255, alpha_end = 0, life_time = 1) =>
    super x, y, sprite
    @alpha = alpha_start
    @alpha_start = alpha_start
    @alpha_end = alpha_end
    @alpha_step = (alpha_end - alpha_start) / life_time
    @draw_health = false
    @id = EntityTypes.particle

  update: (dt) =>
    @sprite\update dt
    if @speed\getLength! > 0
      @position\add @speed\multiply dt
    if @alpha <= @alpha_end
      @kill!
    @elapsed += dt
    if @elapsed >= 1
      @elapsed = 0
      @alpha += @alpha_step
    if @sprite.color
      @sprite.color[4] = @alpha
    else
      @sprite\setColor {255, 255, 255, @alpha}
