export class Upgrade
  new: =>
    @skill_points = 0
    @max_skill = 6

    @player_stats = {0, 0, 0, 0}
    @turret_stats = {0, 0, 0, 0}

    @player_special = {false, false, false, false}
    @turret_special = {false, false, false, false}

  update: (dt) =>
    return

  add_skill: (tree, idx) =>
    print tree, idx
    switch tree
      when Upgrade_Trees.player_stats
        if @player_stats[idx] < @max_skill
          @player_stats[idx] += 1
          @skill_points -= 1
      when Upgrade_Trees.turret_stats
        if @turret_stats[idx] < @max_skill
          @turret_stats[idx] += 1
          @skill_points -= 1
      when Upgrade_Trees.player_special
        if not @player_special[idx]
          @player_special[idx] = true
          @skill_points -= 1
      when Upgrade_Trees.turret_special
        if not @turret_special[idx]
          @turret_special[idx] = true
          @skill_points -= 1

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
    love.graphics.pop!
