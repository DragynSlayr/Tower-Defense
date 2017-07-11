export class GameObject
  new: (x, y, sprite, x_speed = 0, y_speed = 0) =>
    @position = Vector x, y
    @speed = Vector x_speed, y_speed
    @sprite = sprite
    @elapsed = 0
    @health = 5
    @max_health = @health
    @damage = 1
    @alive = true
    @id = nil
    @draw_health = true
    @score_value = 0
    @shielded = false
    @shield_timer = 0
    @max_shield_time = 7
    @solid = true
    @contact_damage = false
    @item_drop_chance = 0.00

    @trail = nil

    @normal_sprite = @sprite
    @action_sprite = @sprite

    @shield_sprite = Sprite "item/shield.tga", 32, 32, 1, 1
    x_scale = @sprite.scaled_width / 32
    y_scale = @sprite.scaled_height / 32
    @shield_sprite\setScale x_scale * 1.5, y_scale * 1.5

    @setArmor 0, @max_health

  setArmor: (armor, max_armor) =>
    @armor = armor
    @max_armor = max_armor
    @armored = @armor > 0

  getHitBox: =>
    -- Get the radius of this Sprite as the minimum of height and width
    radius = math.min @sprite.scaled_height / 2, @sprite.scaled_width / 2

    -- Return a new Circle at this x and y with the radius
    return Circle @position.x, @position.y, radius

  onCollide: (object) =>
    if not @alive return
    if not @shielded
      if @armored
        @armor -= object.damage
        if @armor <= 0
          @health += @armor
        @armored = @armor > 0
      else
        @health -= object.damage
      @health = clamp @health, 0, @max_health
      @armor = clamp @armor, 0, @max_armor

  kill: =>
    score = SCORE + @score_value
    export SCORE = score
    @alive = false
    @health = 0

  update: (dt) =>
    if not @alive return
    if @shielded
      @shield_timer += dt
      if @shield_timer >= @max_shield_time
        @shield_timer = 0
        @shielded = false
    @sprite\update dt
    if @trail
      @trail\update dt
    @health = clamp @health, 0, @max_health
    @armor = clamp @armor, 0, @max_armor
    @armored = @armor > 0

    start = Vector @position.x, @position.y
    @elapsed += dt
    @position\add @speed\multiply dt
    radius = @getHitBox!.radius
    if @id ~= EntityTypes.wall
      @position.x = clamp @position.x, Screen_Size.border[1] + radius, Screen_Size.border[3] - radius
      @position.y = clamp @position.y, Screen_Size.border[2] + radius, (Screen_Size.border[4] + Screen_Size.border[2]) - radius
    if not @solid
      return
    for k, v in pairs Driver.objects
      for k2, o in pairs v
        if not (@id == EntityTypes.wall and o.id == EntityTypes.wall)
          if not ((@id == EntityTypes.player and o.id == EntityTypes.turret) or (@id == EntityTypes.turret and o.id == EntityTypes.player))
            if o ~= @ and o.solid
              other = o\getHitBox!
              this = @getHitBox!
              if other\contains this
                @position = start
                dist = other\getCollisionDistance this
                dist = math.sqrt math.sqrt math.abs dist
                dist_vec = Vector dist, dist
                if @speed\getLength! > 0
                  if @id ~= EntityTypes.player
                    @position\add dist_vec\multiply -1
                if o.speed\getLength! > 0
                  if o.id ~= EntityTypes.player
                    o.position\add dist_vec
                if @contact_damage
                  o\onCollide @
                if o.contact_damage
                  @onCollide o

  draw: =>
    love.graphics.push "all"
    @sprite\draw @position.x, @position.y
    -- Draw bounds if debugging
    if DEBUGGING
      @getHitBox!\draw!
    if @draw_health
      love.graphics.setShader Driver.shader
      love.graphics.setColor 0, 0, 0, 255
      radius = @sprite.scaled_height / 2
      love.graphics.rectangle "fill", (@position.x - radius) - (3 * Scale.width), (@position.y + radius) + (3 * Scale.height), (radius * 2) + (6 * Scale.width), 16 * Scale.height
      love.graphics.setColor 0, 255, 0, 255
      ratio = @health / @max_health
      love.graphics.rectangle "fill", @position.x - radius, (@position.y + radius) + (6 * Scale.height), (radius * 2) * ratio, 10 * Scale.height
      if @armored
        love.graphics.setColor 0, 127, 255, 255
        ratio = @armor / @max_armor
        love.graphics.rectangle "fill", @position.x - radius, (@position.y + radius) + (6 * Scale.height), (radius * 2) * ratio, 10 * Scale.height
      love.graphics.setShader!
    love.graphics.pop!
    if @shielded
      @shield_sprite\draw @position.x, @position.y

  isOnScreen: (bounds = Screen_Size.bounds) =>
    if not @alive return false
    circle = @getHitBox!
    x, y = circle.center\getComponents!
    radius = circle.radius
    xOn = x - radius >= bounds[1] and x + radius <= bounds[3]
    yOn = y - radius >= bounds[2] and y + radius <= bounds[4]
    return xOn and yOn
