EntityTypes = { }
EntityTypes.player = "Player"
EntityTypes.turret = "Turret"
EntityTypes.enemy = "Enemy"
EntityTypes.item = "Item"
EntityTypes.health = "Health"
EntityTypes.coin = "Coin"
EntityTypes.bullet = "Bullet"
EntityTypes.goal = "Goal"
EntityTypes.bomb = "Bomb"
EntityTypes.layers = { }
EntityTypes.layers[EntityTypes.player] = 5
EntityTypes.layers[EntityTypes.turret] = 2
EntityTypes.layers[EntityTypes.enemy] = 4
EntityTypes.layers[EntityTypes.item] = 3
EntityTypes.layers[EntityTypes.health] = 3
EntityTypes.layers[EntityTypes.coin] = 3
EntityTypes.layers[EntityTypes.bullet] = 1
EntityTypes.layers[EntityTypes.goal] = 3
EntityTypes.layers[EntityTypes.bomb] = 1
GoalTypes = { }
GoalTypes.attack = "Attack"
GoalTypes.defend = "Defend"
GoalTypes.find = "Find"
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
Screen_Size.size = {
  Screen_Size.width,
  Screen_Size.height
}
Scale = { }
Scale.width = Screen_Size.width / 1600
Scale.height = Screen_Size.height / 900
Scale.diag = math.sqrt((Screen_Size.width * Screen_Size.width) + (Screen_Size.height * Screen_Size.height)) / math.sqrt((1600 * 1600) + (900 * 900))
Screen_Size.border = {
  0,
  70 * Scale.height,
  Screen_Size.width,
  Screen_Size.height - (140 * Scale.height)
}
Upgrade_Trees = { }
Upgrade_Trees.player_stats = "Player Stats"
Upgrade_Trees.turret_stats = "Turret Stats"
Upgrade_Trees.player_special = "Player Special"
Upgrade_Trees.turret_special = "Turret Special"
Base_Stats = { }
Base_Stats.player = { }
Base_Stats.player[1] = 5
Base_Stats.player[2] = 75 * Scale.diag
Base_Stats.player[3] = 0.5
Base_Stats.player[4] = 275 * Scale.diag
Base_Stats.turret = { }
Base_Stats.turret[1] = 10
Base_Stats.turret[2] = 250 * Scale.diag
Base_Stats.turret[3] = 0.25
Base_Stats.turret[4] = 20
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
