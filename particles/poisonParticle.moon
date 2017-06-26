export class PoisonParticle extends Particle
  new: (x, y, sprite, alpha_start, alpha_end, life_time) =>
    super x, y, sprite, alpha_start, alpha_end, life_time
    @damage = 0.01

  update: (dt) =>
    super dt
    if @alive
      if Driver.objects[EntityTypes.player]
        for k, v in pairs Driver.objects[EntityTypes.player]
          other = v\getHitBox!
          this = @getHitBox!
          if other\contains this
            v\onCollide @
      if Driver.objects[EntityTypes.turret]
        for k, v in pairs Driver.objects[EntityTypes.turret]
          other = v\getHitBox!
          this = @getHitBox!
          if other\contains this
            v\onCollide @
