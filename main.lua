require("logic.classLoader")
DEBUGGING = false
SHOW_RANGE = false
SCORE = 0
GAME_OVER = false
PAUSED = false
love.graphics.setBackgroundColor(50, 75, 50, 255)
love.graphics.setDefaultFilter("nearest", "nearest", 1)
MathHelper = MathHelper()
MusicHandler = MusicHandler()
UI = UI()
Renderer = Renderer()
State = State()
EntityTypes = EntityTypes()
EnemyTypes = EnemyTypes()
GoalTypes = GoalTypes()
Objectives = Objectives()
Driver = Driver()
