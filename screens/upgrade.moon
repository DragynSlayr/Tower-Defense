export class UpgradeScreen extends Screen
  new: =>
    super!

    @skill_points = 0
    --@skill_points = 160
    @max_skill = 6

    @player_stats = {0, 0, 0, 0, 0}
    @turret_stats = {0, 0, 0, 0, 0}
    @upgrade_cost = {1, 1, 2, 2, 3, 3}

    @player_special = {false, false, false, false}
    @turret_special = {false, false, false, false}

    @amount       = {}
    @amount[1]    = {}
    @amount[1][1] = {25 / 8, 50 / 8, 75 / 8, 100 / 8, 125 / 8, 150 / 8}
    @amount[1][2] = {25, 50, 80, 115, 155, 200}
    @amount[1][3] = {5 / 8, 10 / 8, 15 / 8, 20 / 8, 25 / 8, 30 / 8}
    @amount[1][4] = {5, 15, 35, 75, 100, 125}
    @amount[1][5] = {-1 / 70, -2 / 70, -3 / 70, -4 / 70, -5 / 70, -6 / 70}

    @amount[2]    = {}
    @amount[2][1] = {25 / 6, 50 / 6, 75 / 6, 100 / 6, 125 / 6, 150 / 6}
    @amount[2][2] = {15, 30, 50, 70, 100, 150}
    @amount[2][3] = {0.25, 0.75, 1.25, 2.0, 2.8, 3.65}
    @amount[2][4] = {-2.5, -5.0, -7.5, -10.0, -12.5, -15.0}
    @amount[2][5] = {-1 / 540, -2 / 540, -3 / 540, -4 / 540, -5 / 540, -6 / 540}

    for k = 1, #@amount
      for k2 = 1, #@amount[k][2]
        @amount[k][2][k2] *= Scale.diag

    for k = 1, #@amount[1][4]
      @amount[1][4][k] *= Scale.diag

  addPoint: (num) =>
    @skill_points += num

  addSkill: (tree, idx) =>
    switch tree
      when Upgrade_Trees.player_stats
        if @player_stats[idx] < @max_skill
          if @skill_points >= @upgrade_cost[@player_stats[idx] + 1]
            @skill_points -= @upgrade_cost[@player_stats[idx] + 1]
            @player_stats[idx] += 1
            Stats.player[idx] = Base_Stats.player[idx] + (@amount[1][idx][@player_stats[idx]])
            return true
      when Upgrade_Trees.turret_stats
        if @turret_stats[idx] < @max_skill
          if @skill_points >= @upgrade_cost[@turret_stats[idx] + 1]
            @skill_points -= @upgrade_cost[@turret_stats[idx] + 1]
            @turret_stats[idx] += 1
            Stats.turret[idx] = Base_Stats.turret[idx] + (@amount[2][idx][@turret_stats[idx]])
            return true
    return false

  draw: =>
    love.graphics.push "all"
    for j = 0, 1
      for i = 1, #@player_stats
        height = 40 * Scale.height
        width = 600 * Scale.width
        y = ((Screen_Size.height / 3) * (j + 1)) - (150 * Scale.height) + (((i - 1) * 65) * Scale.height)
        x = (0.5 * Screen_Size.width) - (width / 2)
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

    message = "Skill Points: " .. @skill_points
    Renderer\drawHUDMessage message, Screen_Size.width * 0.80, 0
    love.graphics.pop!
