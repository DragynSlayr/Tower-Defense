EntityTypes = { }
EntityTypes.player = "Player"
EntityTypes.turret = "Turret"
EntityTypes.enemy = "Enemy"
EntityTypes.item = "Item"
EntityTypes.health = "Health"
EntityTypes.coin = "Coin"
EntityTypes.bullet = "Bullet"
EntityTypes.goal = "Goal"
EntityTypes.layers = { }
EntityTypes.layers[EntityTypes.player] = 5
EntityTypes.layers[EntityTypes.turret] = 2
EntityTypes.layers[EntityTypes.enemy] = 4
EntityTypes.layers[EntityTypes.item] = 3
EntityTypes.layers[EntityTypes.health] = 3
EntityTypes.layers[EntityTypes.coin] = 3
EntityTypes.layers[EntityTypes.bullet] = 1
EntityTypes.layers[EntityTypes.goal] = 3
GoalTypes = { }
GoalTypes.attack = "Attack"
GoalTypes.defend = "Defend"
EnemyTypes = { }
EnemyTypes.player = "PlayerEnemy"
EnemyTypes.turret = "TurretEnemy"
EnemyTypes.spawner = "SpawnerEnemy"
EnemyTypes.strong = "StrongEnemy"
EnemyTypes.basic = "BasicEnemy"
Scaling = { }
Scaling.health = 5
Scaling.damage = 0.5
Scaling.speed = 5
Upgrade_Trees = { }
Upgrade_Trees.player_stats = "Player Stats"
Upgrade_Trees.turret_stats = "Turret Stats"
Upgrade_Trees.player_special = "Player Special"
Upgrade_Trees.turret_special = "Turret Special"
Screen_State = { }
Screen_State.main_menu = "Main Menu"
Screen_State.pause_menu = "Pause Menu"
Screen_State.game_over = "Game Over"
Screen_State.upgrade = "Upgrade"
Screen_State.scores = "Scores"
Screen_State.loading = "Loading"
Screen_State.none = "None"
Game_State = { }
Game_State.main_menu = "Main Menu"
Game_State.paused = "Paused"
Game_State.game_over = "Game Over"
Game_State.playing = "Playing"
Game_State.upgrading = "Upgrading"
Game_State.none = "None"
Screen_Size = { }
Screen_Size.width = love.graphics.getWidth()
Screen_Size.height = love.graphics.getHeight()
Screen_Size.half_width = Screen_Size.width / 2
Screen_Size.half_height = Screen_Size.height / 2
Screen_Size.bounds = {
  0,
  0,
  Screen_Size.width,
  Screen_Size.height
}
Screen_Size.border = {
  0,
  70,
  Screen_Size.width,
  Screen_Size.height - 140
}
