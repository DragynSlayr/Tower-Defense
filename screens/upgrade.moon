export class UpgradeScreen extends Screen
  new: =>
    super!

    @skill_points = 0
    --@skill_points = 100
    @max_skill = 6

    @player_stats = {0, 0, 0, 0, 0}
    @turret_stats = {0, 0, 0, 0, 0}

    @player_special = {false, false, false, false}
    @turret_special = {false, false, false, false}

    @amount       = {}
    @amount[1]    = {}
    @amount[1][1] = {5, 11, 18, 26, 35, 45}
    @amount[1][2] = {25, 50, 80, 115, 155, 200}
    @amount[1][3] = {0.2, 0.5, 1.0, 1.5, 2.0, 2.8}
    @amount[1][4] = {50, 100, 175, 250, 325, 400}
    @amount[1][5] = {-1 / 450, -2 / 450, -3 / 450, -4 / 450, -5 / 450, -6 / 450}

    @amount[2]    = {}
    @amount[2][1] = {4, 8, 13, 18, 24, 32}
    @amount[2][2] = {15, 30, 50, 70, 100, 150}
    @amount[2][3] = {0.25, 0.75, 1.25, 2.0, 2.8, 3.65}
    @amount[2][4] = {-2.5, -5.0, -7.5, -10.0, -12.5, -15.0}
    @amount[2][5] = {-1 / 540, -2 / 540, -3 / 540, -4 / 540, -5 / 540, -6 / 540}

    for k = 1, #@amount
      for k2 = 1, #@amount[k][2]
        @amount[k][2][k2] *= Scale.diag

    for k = 1, #@amount[1][4]
      @amount[1][4][k] *= Scale.diag

  add_point: (num) =>
    @skill_points += num

  add_skill: (tree, idx) =>
    success = false
    if @skill_points >= 1
      switch tree
        when Upgrade_Trees.player_stats
          if @player_stats[idx] < @max_skill
            @player_stats[idx] += 1
            @skill_points -= 1
            Stats.player[idx] = Base_Stats.player[idx] + (@amount[1][idx][@player_stats[idx]])--(@player_stats[idx] * @amount[1][idx])
            success = true
        when Upgrade_Trees.turret_stats
          if @turret_stats[idx] < @max_skill
            @turret_stats[idx] += 1
            @skill_points -= 1
            Stats.turret[idx] = Base_Stats.turret[idx] + (@amount[2][idx][@turret_stats[idx]])--(@turret_stats[idx] * @amount[2][idx])
            success = true
    if @skill_points >= 5
      switch tree
        when Upgrade_Trees.player_special
          if not @player_special[idx]
            @player_special[idx] = true
            @skill_points -= 5
            success = true
        when Upgrade_Trees.turret_special
          if not @turret_special[idx]
            @turret_special[idx] = true
            @skill_points -= 5
            success = true
    return success

  draw: =>
    love.graphics.push "all"
    for j = 0, 1
      for i = 1, #@player_stats
        height = 40 * Scale.height
        width = 600 * Scale.width
        y = (25 * Scale.height) + (i * 65 * Scale.height) - (height / 2) + (425 * j * Scale.height)
        x = 320 * Scale.width
        ratio = @player_stats[i] / @max_skill
        if j == 1
          ratio = @turret_stats[i] / @max_skill

        love.graphics.setColor 178, 150, 0, 255
        love.graphics.rectangle "fill", x, y, width, height

        love.graphics.setColor 255, 215, 0, 255
        love.graphics.rectangle "fill", x + (3 * Scale.width), y + (3 * Scale.height), (width - (6 * Scale.width)) * ratio, height - (6 * Scale.height)

        love.graphics.setColor 0, 0, 0, 255
        for i = x, x + width, width / @max_skill
          love.graphics.line i, y, i, y + height

        stats = Stats.player
        if j == 1
          stats = Stats.turret

        message = string.format "%.3f", stats[i]
        Renderer\drawHUDMessage message, Screen_Size.width * 0.8, y

    message = "Skill Points: " .. @skill_points
    Renderer\drawHUDMessage message, Screen_Size.width - (Renderer.hud_font\getWidth message) - (5 * Scale.width), 0
    love.graphics.pop!
