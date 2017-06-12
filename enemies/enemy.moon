export class Enemy extends GameObject
  new: (x, y, sprite, attack_delay, attack_speed, target = nil) =>
    super x, y, sprite
    @target = target
    bounds = @sprite\getBounds 0, 0
    @attack_range = bounds.radius * 2
    @delay = attack_delay
    @id = EntityTypes.enemy
    --@health = @health + (Scaling.health * Objectives\getLevel!)
    --@max_health = @health
    --@damage = @damage + (Scaling.damage * Objectives\getLevel!)
    @max_speed = 150 * Scale.diag-- + (Scaling.speed * Objectives\getLevel!)
    @speed_multiplier = @max_speed
    @value = 1
    @attacked_once = false

    splitted = split @normal_sprite.name, "."
    name = splitted[1] .. "Action." .. splitted[2]
    height, width, _, scale = @normal_sprite\getProperties!

    @action_sprite = ActionSprite name, height, width, attack_speed, scale, @, () =>
      target = @parent.target\getHitBox!
      enemy = @parent\getHitBox!
      enemy.radius += @parent.attack_range
      if target\contains enemy
        @parent.elapsed = 0
        @parent.target\onCollide @parent
        @parent.speed_multiplier = 0
        if @parent.target.health <= 0
          @parent\findNearestTarget!

  __tostring: =>
    return "Enemy"

  onCollide: (object) =>
    if not @alive return
    super object
    if object.slowing
      @speed_multiplier = 0

  update: (dt, search = false) =>
    if not @alive return
    @findNearestTarget search
    if not @target return
    dist = @position\getDistanceBetween @target.position
    if dist < love.graphics.getWidth! / 4
      @speed = Vector @target.position.x - @position.x, @target.position.y - @position.y
      @speed\toUnitVector!
      @speed = @speed\multiply clamp @speed_multiplier, 0, @max_speed
      @speed_multiplier += 1
      super dt
      vec = Vector 0, 0
      @sprite.rotation = @speed\getAngleBetween vec

      target = @target\getHitBox!
      if @target.getAttackHitBox
        target = @target\getAttackHitBox!
      enemy = @getHitBox!
      enemy.radius += @attack_range
      can_attack = target\contains enemy
      if can_attack
        if @attacked_once
          if @elapsed >= @delay
            @sprite = @action_sprite
        else
          @sprite = @action_sprite
          @attacked_once = true
    else
      @speed = Vector @target.position.x - @position.x, @target.position.y - @position.y
      length = @speed\getLength!
      x = @speed.x / length
      y = @speed.y / length
      diff = math.abs x - y
      if diff <= 1.3 and diff >= 0.05
        copy = @speed\getAbsolute!
        --print @speed\__tostring! .. ", " .. copy\__tostring!
        if copy.x > copy.y
          @speed = Vector @speed.x, 0
        elseif copy.x < copy.y
          @speed = Vector 0, @speed.y
      @speed\toUnitVector!
      @speed = @speed\multiply clamp @speed_multiplier, 0, @max_speed
      @speed_multiplier += 1
      super dt
      vec = Vector 0, 0
      @sprite.rotation = @speed\getAngleBetween vec

  draw: =>
    if not @alive return
    love.graphics.push "all"
    if DEBUGGING
      love.graphics.setColor 255, 0, 255, 127
    if @sprite == @action_sprite
      alpha = map @action_sprite.current_frame, 1, @action_sprite.frames, 100, 255
      love.graphics.setColor 255, 0, 0, alpha
    if DEBUGGING --or @sprite == @action_sprite
      @getHitBox!\draw!
    love.graphics.pop!
    super!

  findNearestTarget: (all = false) =>
    closest = nil
    closest_distance = math.max love.graphics.getWidth! * 2, love.graphics.getHeight! * 2
    if Driver.objects[EntityTypes.player]
      for k, v in pairs Driver.objects[EntityTypes.player]
        player = v\getHitBox!
        enemy = @getHitBox!
        dist = Vector enemy.center.x - player.center.x, enemy.center.y - player.center.y
        if dist\getLength! < closest_distance
          closest_distance = dist\getLength!
          closest = v
    if Driver.objects[EntityTypes.turret]
      for k, v in pairs Driver.objects[EntityTypes.turret]
        turret = v\getHitBox!
        enemy = @getHitBox!
        dist = Vector enemy.center.x - turret.center.x, enemy.center.y - turret.center.y
        if dist\getLength! < closest_distance
          closest_distance = dist\getLength!
          closest = v
    if Driver.objects[EntityTypes.goal]
      for k, v in pairs Driver.objects[EntityTypes.goal]
        if v.goal_type == GoalTypes.defend
          goal = v\getHitBox!
          enemy = @getHitBox!
          dist = Vector enemy.center.x - goal.center.x, enemy.center.y - goal.center.y
          if dist\getLength! < closest_distance
            closest_distance = dist\getLength!
            closest = v
    @target = closest
