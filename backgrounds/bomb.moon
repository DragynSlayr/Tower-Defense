export class Bomb extends BackgroundObject
  new: (x, y) =>
    sprite = Sprite "background/bomb.tga", 32, 32, 1, 2
    super x, y, sprite

    @max_time = 0
    @attack_range = 100 * Scale.diag
    @action_sprite = ActionSprite "background/bombAction.tga", 32, 32, 3, 2, @, () =>
      if Driver.objects[EntityTypes.enemy]
        for k, e in pairs Driver.objects[EntityTypes.enemy]
          target = e\getHitBox!
          bomb = @parent\getHitBox!
          bomb.radius += @parent.attack_range
          if target\contains bomb
            e\kill!
      if Driver.objects[EntityTypes.goal]
        goals = {GoalTypes.tesseract, GoalTypes.attack, GoalTypes.find}
        for k, e in pairs Driver.objects[EntityTypes.goal]
          if tableContains goals, e.goal_type
            target = e\getHitBox!
            bomb = @parent\getHitBox!
            bomb.radius += @parent.attack_range
            if target\contains bomb
              e\kill!
      if Driver.objects[EntityTypes.boss]
        for k, b in pairs Driver.objects[EntityTypes.boss]
          target = b\getHitBox!
          bomb = @parent\getHitBox!
          bomb.radius += @parent.attack_range
          if target\contains bomb
            b\kill!
      @parent\kill!

  update: (dt) =>
    super dt
    if @elapsed >= @max_time
      @sprite = @action_sprite

  draw: =>
    love.graphics.push "all"
    love.graphics.setShader Driver.shader
    color = map @action_sprite.current_frame, 1, @action_sprite.frames, 200, 0
    love.graphics.setColor color, color, color, 127
    bounds = @getHitBox!
    love.graphics.circle "fill", @position.x, @position.y, bounds.radius + @attack_range, 360
    love.graphics.setShader!
    love.graphics.pop!
    super!
