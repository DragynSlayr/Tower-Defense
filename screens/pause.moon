export class Pause extends Screen
  new: =>
    super!
    @font = Renderer\newFont 20
    @stats = {"max_health", "damage", "speed_multiplier", "score_value"}
    @sprites = {(Sprite "enemy/tracker.tga", 32, 32, 1, 1.25), (Sprite "enemy/enemy.tga", 26, 26, 1, 0.75), (Sprite "projectile/dart.tga", 17, 17, 1, 2), (Sprite "enemy/bullet.tga", 26, 20, 1, 2), (Sprite "enemy/circle.tga", 26, 26, 1, 1.75)}
    @icons = {(Sprite "icons/health.tga", 16, 16, 1, 1), (Sprite "icons/damage.tga", 16, 16, 1, 1), (Sprite "icons/speed.tga", 16, 16, 1, 1), (Sprite "icons/score.tga", 16, 16, 1, 1)}

  getEnemies: () =>
    basic   = BasicEnemy 0, 0
    player  = PlayerEnemy 0, 0
    spawner = SpawnerEnemy 0, 0
    strong  = StrongEnemy 0, 0
    turret  = TurretEnemy 0, 0
    return {basic, player, spawner, strong, turret}

  draw: =>
    love.graphics.push "all"
    enemies = @getEnemies!
    for i = 1, #enemies
      x = map i, 1, #enemies, 100 * Scale.width, Screen_Size.width - (200 * Scale.width)
      y = Screen_Size.height * 0.8
      bounds = @sprites[i]\getBounds x, y
      for j = 1, #@stats
        --y += 30
        y = map j, 1, #@stats, (Screen_Size.height * 0.8) + (30 * Scale.height), Screen_Size.height * 0.96
        @icons[j]\draw x, y + (9 * Scale.height)
        Renderer\drawHUDMessage enemies[i][@stats[j]], x + (10 * Scale.width) + bounds.radius, y, @font
    love.graphics.pop!
