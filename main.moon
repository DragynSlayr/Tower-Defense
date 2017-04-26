require "logic.classLoader"

-- Enable to show extra info
export DEBUGGING = not true

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

-- Global Player
export Player = Player love.graphics.getWidth! / 2, love.graphics.getHeight! / 2, Sprite "test.tga", 16, 16, 0.29, 4
Player.sprite\setRotationSpeed -math.pi / 2

-- Create Driver object
export Driver = Driver!
Driver\addObject Player, EntityTypes.player

return
