export class SpawnerEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "projectile/dart.tga", 17, 17, 1, 2
    super x, y, sprite
    @enemyType = EnemyTypes.spawner
    @score_value = 50

    @health = 5 + (2.5 * Objectives\getLevel!)
    @max_health = @health
    @max_speed = 150 + (5 * Objectives\getLevel!)
    @speed_multiplier = @max_speed
    @damage = 1 + (1 * Objectives\getLevel!)

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
