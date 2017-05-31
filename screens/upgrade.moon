export class Upgrade extends Screen
  new: =>
    super!

    @skill_points = 0
    --@skill_points = 88
    @max_skill = 6

    @player_stats = {0, 0, 0, 0}
    @turret_stats = {0, 0, 0, 0}

    @player_special = {false, false, false, false}
    @turret_special = {false, false, false, false}

    @amount = {}
    @amount[1] = {{2, 4, 8, 13, 20, 30}, {25, 50, 80, 115, 155, 200}, {0.2, 0.4, 0.9, 1.4, 2.2, 3.2}, {50, 100, 175, 250, 325, 400}}
    @amount[2] = {{2, 4, 6, 9, 13, 18}, {15, 30, 50, 70, 100, 150}, {0.025, 0.525, 1.025, 1.825, 2.825, 3.825}, {-2.5, -5.0, -7.5, -10.0, -12.5, -15.0}}

  add_point: (num) =>
    @skill_points += num

  add_skill: (tree, idx) =>
    if @skill_points >= 1
      switch tree
        when Upgrade_Trees.player_stats
          if @player_stats[idx] < @max_skill
            @player_stats[idx] += 1
            @skill_points -= 1
            Stats.player[idx] = Base_Stats.player[idx] + (@amount[1][idx][@player_stats[idx]])--(@player_stats[idx] * @amount[1][idx])
        when Upgrade_Trees.turret_stats
          if @turret_stats[idx] < @max_skill
            @turret_stats[idx] += 1
            @skill_points -= 1
            Stats.turret[idx] = Base_Stats.turret[idx] + (@amount[2][idx][@turret_stats[idx]])--(@turret_stats[idx] * @amount[2][idx])
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

        stats = Stats.player
        if j == 1
          stats = Stats.turret

        message = stats[i]
        Renderer\drawHUDMessage message, Screen_Size.width * 0.8, y

    message = "Skill Points: " .. @skill_points
    Renderer\drawHUDMessage message, Screen_Size.width - (Renderer.hud_font\getWidth message) - 5, 0
    love.graphics.pop!
