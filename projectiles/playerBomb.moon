export class PlayerBomb extends GameObject
  new: (x, y) =>
    sprite = Sprite "bomb.tga", 32, 32, 1, 2
    super x, y, sprite

    @max_time = 0
    @attack_range = 100 * Scale.diag
    --@damage = Stats.player[3] * 20--10 + (5 * Upgrade.player_stats[3])
    @draw_health = false
    @id = EntityTypes.bomb

    @action_sprite = ActionSprite "bombAction.tga", 32, 32, 3, 2, @, () =>
      if Driver.objects[EntityTypes.enemy]
        for k, e in pairs Driver.objects[EntityTypes.enemy]
          target = e\getHitBox!
          bomb = @parent\getHitBox!
          bomb.radius += @parent.attack_range
          if target\contains bomb
            e\kill!--onCollide @parent
      if Driver.objects[EntityTypes.goal]
        for k, e in pairs Driver.objects[EntityTypes.goal]
          if e.goal_type == GoalTypes.attack
            target = e\getHitBox!
            bomb = @parent\getHitBox!
            bomb.radius += @parent.attack_range
            if target\contains bomb
              e\kill!--onCollide @parent
      @parent\kill!

  update: (dt) =>
    super dt
    if @elapsed >= @max_time
      @sprite = @action_sprite

  draw: =>
    --if DEBUGGING
    love.graphics.push "all"
    love.graphics.setShader Driver.shader
    color = map @action_sprite.current_frame, 1, @action_sprite.frames, 200, 0
    love.graphics.setColor color, color, color, 127
    bounds = @getHitBox!
    love.graphics.circle "fill", @position.x, @position.y, bounds.radius + @attack_range, 360
    love.graphics.setShader!
    love.graphics.pop!
    super!
