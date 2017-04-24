require "logic.classLoader"

export DEBUGGING = false

-- Set love environment
love.graphics.setBackgroundColor 200, 200, 200
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

-- Global Player
export Player = Player 250, 250, Sprite "test.tga", 16, 16, 1, 4
Player.sprite\setRotationSpeed 0

-- Create Driver object
export Driver = Driver!
Driver\addObject Player, EntityTypes.player

return
