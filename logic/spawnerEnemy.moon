export class SpawnerEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "projectile/dart.tga", 17, 17, 1, 2
    super x, y, sprite
    @enemyType = EnemyTypes.spawner

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
