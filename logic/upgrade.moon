export class Upgrade
  new: =>
    @skill_points = 88
    @max_skill = 6

    @player_stats = {0, 0, 0, 0}
    @turret_stats = {0, 0, 0, 0}

    @player_special = {false, false, false, false}
    @turret_special = {false, false, false, false}

    @amount = {}
    @amount[1] = {2, 55, 1.0, 25}
    @amount[2] = {2, 50, 1.5, -2.5}

  update: (dt) =>
    return

  add_point: (num) =>
    @skill_points += num

  add_skill: (tree, idx) =>
    print tree, idx
    if @skill_points >= 1
      switch tree
        when Upgrade_Trees.player_stats
          if @player_stats[idx] < @max_skill
            @player_stats[idx] += 1
            @skill_points -= 1
        when Upgrade_Trees.turret_stats
          if @turret_stats[idx] < @max_skill
            @turret_stats[idx] += 1
            @skill_points -= 1
    if @skill_points >= 5
      switch tree
        when Upgrade_Trees.player_special
          if not @player_special[idx]
            @player_special[idx] = true
            @skill_points -= 5
        when Upgrade_Trees.turret_special
          if not @turret_special[idx]
            @turret_special[idx] = true
            @skill_points -= 5

  draw: =>
    love.graphics.push "all"
    for j = 0, 1
      for i = 1, 4
        height = 40
        width = 600
        y = 100 + (i * 65) - (height / 2) + (400 * j)
        x = 320
        ratio = @player_stats[i] / @max_skill
        if j == 1
          ratio = @turret_stats[i] / @max_skill

        love.graphics.setColor 178, 150, 0, 255
        love.graphics.rectangle "fill", x, y, width, height

        love.graphics.setColor 255, 215, 0, 255
        love.graphics.rectangle "fill", x + 3, y + 3, (width - 6) * ratio, height - 6

        love.graphics.setColor 0, 0, 0, 255
        for i = x, x + width, width / @max_skill
          love.graphics.line i, y, i, y + height

        stats = Player.base_stats!
        if j == 1
          stats = Turret.base_stats!

        message = stats[i]
        if j == 0
          message += (@player_stats[i] * @amount[1][i])
        else
          message += (@turret_stats[i] * @amount[2][i])
        Renderer\drawHUDMessage message, Screen_Size.width * 0.8, y

    message = "Skill Points: " .. @skill_points
    Renderer\drawHUDMessage message, Screen_Size.width - (Renderer.hud_font\getWidth message) - 5, 0
    love.graphics.pop!
