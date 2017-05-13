require "logic.classLoader"

-- Enable to show extra info
export DEBUGGING = false
export SHOW_RANGE = false

-- Global stats
export SCORE = 0
export GAME_OVER = false
export PAUSED = false

-- Set love environment
love.graphics.setBackgroundColor 50, 75, 50, 255
love.graphics.setDefaultFilter "nearest", "nearest", 1

-- Global MathHelper
export MathHelper = MathHelper!

-- Global MusicHandler
export MusicHandler = MusicHandler!

-- Global UI
export UI = UI!

-- Global Renderer
export Renderer = Renderer!

-- Global State
export State = State!
export EntityTypes = EntityTypes!
export EnemyTypes = EnemyTypes!
export GoalTypes = GoalTypes!

-- Global objectives
export Objectives = Objectives!

-- Create Driver object
export Driver = Driver!

return
