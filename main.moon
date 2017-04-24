require "logic.classLoader"

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

-- Global Player
export Player = Player 100, 1024, Sprite "test.tga", 16, 16, 1, 4
Player.sprite\setRotationSpeed 11

-- Create Driver object
Driver!

return
