export EntityTypes = {}

EntityTypes.player     = "Player"
EntityTypes.turret     = "Turret"
EntityTypes.enemy      = "Enemy"
EntityTypes.item       = "Item"
EntityTypes.health     = "Health"
EntityTypes.coin       = "Coin"
EntityTypes.bullet     = "Bullet"
EntityTypes.goal       = "Goal"
EntityTypes.background = "Background"
EntityTypes.wall       = "Wall"
EntityTypes.particle   = "Particle"
EntityTypes.boss       = "Boss"

EntityTypes.layers = {}

EntityTypes.layers[EntityTypes.player]     = 8
EntityTypes.layers[EntityTypes.turret]     = 5
EntityTypes.layers[EntityTypes.enemy]      = 7
EntityTypes.layers[EntityTypes.item]       = 5
EntityTypes.layers[EntityTypes.health]     = 5
EntityTypes.layers[EntityTypes.coin]       = 5
EntityTypes.layers[EntityTypes.bullet]     = 4
EntityTypes.layers[EntityTypes.goal]       = 6
EntityTypes.layers[EntityTypes.background] = 2
EntityTypes.layers[EntityTypes.wall]       = 1
EntityTypes.layers[EntityTypes.particle]   = 3
EntityTypes.layers[EntityTypes.boss]       = 7

export ModeTypes = {}

ModeTypes.dark        = "Dark Mode"
ModeTypes.elimination = "Elimination Mode"
ModeTypes.attack      = "Attack Mode"
ModeTypes.defend      = "Defend Mode"
ModeTypes.capture     = "Capture Mode"
ModeTypes.boss        = "Boss Mode"

export GoalTypes = {}

GoalTypes.attack    = "Attack"
GoalTypes.defend    = "Defend"
GoalTypes.find      = "Find"
GoalTypes.capture   = "Capture"
GoalTypes.tesseract = "Tesseract"

export EnemyTypes = {}

EnemyTypes.player  = "PlayerEnemy"
EnemyTypes.turret  = "TurretEnemy"
EnemyTypes.spawner = "SpawnerEnemy"
EnemyTypes.strong  = "StrongEnemy"
EnemyTypes.basic   = "BasicEnemy"
EnemyTypes.capture = "CaptureEnemy"

export ParticleTypes = {}

ParticleTypes.normal = "NormalParticle"
ParticleTypes.poison = "PoisonParticle"

export ItemTypes = {}

ItemTypes.passive = "PassiveItem"
ItemTypes.active  = "ActiveItem"

export ItemFrameTypes = {}

ItemFrameTypes.passive         = "PassiveFrame"
ItemFrameTypes.active          = "ActiveFrame"
ItemFrameTypes.equippedActive  = "EquippedActive"
ItemFrameTypes.equippedPassive = "EquippedPassive"
ItemFrameTypes.transfer        = "Transfer"
ItemFrameTypes.default         = "Default"

export BossTypes = {}

BossTypes.vyder = "Vyder"

export Scaling = {}

Scaling.health = 5
Scaling.damage = 0.5
Scaling.speed  = 5

export Screen_Size = {}

Screen_Size.width       = love.graphics.getWidth!
Screen_Size.height      = love.graphics.getHeight!
Screen_Size.half_width  = Screen_Size.width / 2
Screen_Size.half_height = Screen_Size.height / 2
Screen_Size.bounds      = {0, 0, Screen_Size.width, Screen_Size.height}
Screen_Size.size        = {Screen_Size.width, Screen_Size.height}

export Scale = {}

Scale.width  = Screen_Size.width / 1600
Scale.height = Screen_Size.height / 900
Scale.diag   = math.sqrt((Screen_Size.width * Screen_Size.width) + (Screen_Size.height * Screen_Size.height)) / math.sqrt((1600 * 1600) + (900 *900))

Screen_Size.border = {0, 70 * Scale.height, Screen_Size.width, Screen_Size.height - (140 * Scale.height)}

export Upgrade_Trees = {}

Upgrade_Trees.player_stats   = "Player Stats"
Upgrade_Trees.turret_stats   = "Turret Stats"
Upgrade_Trees.player_special = "Player Special"
Upgrade_Trees.turret_special = "Turret Special"

export Base_Stats = {}

Base_Stats.player = {}

-- "Health", "Range", "Damage", "Speed", "Attack Delay"
Base_Stats.player[1] = 25
Base_Stats.player[2] = 75 * Scale.diag
Base_Stats.player[3] = 0.5
Base_Stats.player[4] = 275 * Scale.diag
Base_Stats.player[5] = 1 / 75

Base_Stats.turret = {}

-- "Health", "Range", "Damage", "Cooldown", "Attack Delay"
Base_Stats.turret[1] = 12.5
Base_Stats.turret[2] = 250 * Scale.diag
Base_Stats.turret[3] = 0.25
Base_Stats.turret[4] = 20
Base_Stats.turret[5] = 1 / 90

export Screen_State = {}

Screen_State.main_menu  = "Main Menu"
Screen_State.pause_menu = "Pause Menu"
Screen_State.game_over  = "Game Over"
Screen_State.upgrade    = "Upgrade"
Screen_State.scores     = "Scores"
Screen_State.loading    = "Loading"
Screen_State.none       = "None"
Screen_State.inventory  = "Inventory"

export Game_State = {}

Game_State.main_menu = "Main Menu"
Game_State.paused    = "Paused"
Game_State.game_over = "Game Over"
Game_State.playing   = "Playing"
Game_State.upgrading = "Upgrading"
Game_State.none      = "None"
Game_State.inventory = "Inventory"
