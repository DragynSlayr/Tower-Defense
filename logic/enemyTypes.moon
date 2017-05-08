export class EnemyTypes
  new: =>
    @player   = "PlayerEnemy"
    @turret   = "TurretEnemy"
    @spawner  = "SpawnerEnemy"
    @strong   = "StrongEnemy"
    @basic    = "BasicEnemy"

    @num_enemies = 5
