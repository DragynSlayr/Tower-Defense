export class PauseScreen extends Screen
  new: =>
    super!
    @font = Renderer\newFont 20
    @stats = {"max_health", "damage", "speed_multiplier", "score_value"}
    @sprites = {(Sprite "enemy/tracker.tga", 32, 32, 1, 50 / 32), (Sprite "enemy/enemy.tga", 26, 26, 1, 50 / 26), (Sprite "projectile/dart.tga", 17, 17, 1, 50 / 17), (Sprite "enemy/bullet.tga", 26, 20, 1, 50 / 26), (Sprite "enemy/circle.tga", 26, 26, 1, 50 / 26)}
    @sprites2 = {(Sprite "test.tga", 16, 16, 0.29, 50 / 16), (Sprite "turret.tga", 34, 16, 2, 50 / 34)}
    @icons = {(Sprite "icons/health.tga", 16, 16, 1, 1), (Sprite "icons/damage.tga", 16, 16, 1, 1), (Sprite "icons/speed.tga", 16, 16, 1, 1), (Sprite "icons/score.tga", 16, 16, 1, 1)}
    @player_icons = {@icons[1], (Sprite "icons/range.tga", 16, 16, 1, 1), @icons[2], @icons[3], (Sprite "icons/attack_delay.tga", 16, 16, 1, 1)}
    @turret_icons = {@icons[1], (Sprite "icons/range.tga", 16, 16, 1, 1), @icons[2], (Sprite "icons/cooldown.tga", 16, 16, 1, 1), (Sprite "icons/attack_delay.tga", 16, 16, 1, 1)}

  getEnemies: () =>
    basic   = BasicEnemy 0, 0
    player  = PlayerEnemy 0, 0
    spawner = SpawnerEnemy 0, 0
    strong  = StrongEnemy 0, 0
    turret  = TurretEnemy 0, 0
    return {basic, player, spawner, strong, turret}

  draw: =>
    love.graphics.push "all"
    for j = 1, 2
      y = Screen_Size.height * 0.4
      stats = Stats.player
      x = Screen_Size.width * 0.2
      icons = @player_icons
      if j == 2
        stats = Stats.turret
        x = Screen_Size.width * 0.8
        icons = @turret_icons
      bounds = @sprites2[j]\getBounds x, y
      for i = 1, #stats
        y = map i, 1, #stats, (Screen_Size.height * 0.4) + (40 * Scale.height), Screen_Size.height * 0.60
        icons[i]\draw x, y + (9 * Scale.height)
        Renderer\drawHUDMessage (string.format "%.2f", stats[i]), x + (10 * Scale.width) + bounds.radius, y, @font
    enemies = @getEnemies!
    for i = 1, #enemies
      x = map i, 1, #enemies, 100 * Scale.width, Screen_Size.width - (200 * Scale.width)
      y = Screen_Size.height * 0.8
      bounds = @sprites[i]\getBounds x, y
      for j = 1, #@stats
        --y += 30
        y = map j, 1, #@stats, (Screen_Size.height * 0.8) + (30 * Scale.height), Screen_Size.height * 0.96
        @icons[j]\draw x, y + (9 * Scale.height)
        Renderer\drawHUDMessage (string.format "%.2f", enemies[i][@stats[j]]), x + (10 * Scale.width) + bounds.radius, y, @font
    love.graphics.pop!
