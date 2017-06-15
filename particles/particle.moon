export class Particle extends GameObject
  new: (x, y, sprite, alpha_start = 255, alpha_end = 0, life_time = 1) =>
    super x, y, sprite\getCopy!
    @alpha = alpha_start
    @alpha_start = alpha_start
    @alpha_end = alpha_end
    @alpha_step = (alpha_end - alpha_start) / (life_time * 60)
    @draw_health = false
    @id = EntityTypes.particle
    @sprite.color[4] = @alpha

    @setShader love.graphics.newShader "shaders/normal.fs"

  setShader: (shader, apply = false) =>
    @sprite\setShader shader
    @block_shader = apply
    @sprite.should_shade = @block_shader

  update: (dt) =>
    @sprite\update dt
    if @sprite.should_shade ~= @block_shader
      @sprite.should_shade = @block_shader
    if @speed\getLength! > 0
      @position\add @speed\multiply dt
    @alpha += @alpha_step
    if @alpha < @alpha_end
      @kill!
    else
      @sprite.color[4] = math.floor @alpha
