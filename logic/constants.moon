export EntityTypes = {}

EntityTypes.player = "Player"
EntityTypes.turret = "Turret"
EntityTypes.enemy  = "Enemy"
EntityTypes.item   = "Item"
EntityTypes.health = "Health"
EntityTypes.coin   = "Coin"
EntityTypes.bullet = "Bullet"
EntityTypes.goal   = "Goal"

EntityTypes.layers = {}
EntityTypes.layers[EntityTypes.player] = 5
EntityTypes.layers[EntityTypes.turret] = 2
EntityTypes.layers[EntityTypes.enemy]  = 4
EntityTypes.layers[EntityTypes.item]   = 3
EntityTypes.layers[EntityTypes.health] = 3
EntityTypes.layers[EntityTypes.coin]   = 3
EntityTypes.layers[EntityTypes.bullet] = 1
EntityTypes.layers[EntityTypes.goal]   = 2

export GoalTypes = {}

GoalTypes.attack = "Attack"
GoalTypes.defend = "Defend"

export EnemyTypes = {}

EnemyTypes.player  = "PlayerEnemy"
EnemyTypes.turret  = "TurretEnemy"
EnemyTypes.spawner = "SpawnerEnemy"
EnemyTypes.strong  = "StrongEnemy"
EnemyTypes.basic   = "BasicEnemy"
