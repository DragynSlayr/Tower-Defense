require "logic.constants"
require "logic.globals"
require "logic.classLoader"

-- Enable to show extra info
export DEBUGGING = false
export SHOW_RANGE = false

-- Global stats
export SCORE = 0

-- Set love environment
--love.graphics.setBackgroundColor 91, 192, 255, 255
--love.graphics.setBackgroundColor 75, 163, 255, 255
love.graphics.setDefaultFilter "nearest", "nearest", 1

-- Global MusicHandler
export MusicHandler = MusicHandler!

-- Global UI
export UI = UI!

-- Global Renderer
export Renderer = Renderer!

-- Global objectives
export Objectives = Objectives!

-- Create upgrade object
export Upgrade = Upgrade!

-- Create Driver object
export Driver = Driver!
