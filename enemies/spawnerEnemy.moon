export class SpawnerEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "projectile/dart.tga", 17, 17, 1, 2
    super x, y, sprite
    @enemyType = EnemyTypes.spawner
    @score_value = 50

    @health = 12 + (13.2 * Objectives\getLevel!)
    @max_health = @health
    @max_speed = (150 + (10 * Objectives\getLevel!)) * Scale.diag
    @speed_multiplier = @max_speed
    @damage = 1 + (0.13 * Objectives\getLevel!)

  __tostring: =>
    return "T: " .. @enemyType .. "\tH: " .. @max_health .. "\tD: " .. @damage .. "\tS: " .. @max_speed

  kill: =>
    super!

    enemy = PlayerEnemy @position.x - 10, @position.y
    enemy.id = EntityTypes.bullet
    Driver\addObject enemy, EntityTypes.enemy

    enemy = PlayerEnemy @position.x + 10, @position.y
    enemy.id = EntityTypes.bullet
    Driver\addObject enemy, EntityTypes.enemy

    enemy = PlayerEnemy @position.x, @position.y - 10
    enemy.id = EntityTypes.bullet
    Driver\addObject enemy, EntityTypes.enemy

    enemy = PlayerEnemy @position.x, @position.y + 10
    enemy.id = EntityTypes.bullet
    Driver\addObject enemy, EntityTypes.enemy
