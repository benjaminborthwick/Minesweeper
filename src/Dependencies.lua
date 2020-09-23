

-- libraries
Class = require 'lib/class'
push = require 'lib/push'


-- utility
require 'src/constants'
require 'src/StateMachine'


-- game states
require 'src/states/PlayState'
require 'src/states/StartState'
require 'src/states/LoseState'
require 'src/states/WinState'


-- general
require 'src/constants'
require 'src/MapMaker'
require 'src/Tile'

gFont = love.graphics.newFont('fonts/font.ttf', 72)
gSheet = love.graphics.newImage('graphics/spritesheet.png')

gFrames = {
    ['numbers'] = {},
    ['tiles'] = {}
}

local sheetCounter = 1
for y = 0, 3 do
    for x = 0, 3 do
        if sheetCounter < 10 then
            gFrames['numbers'][sheetCounter] =
                love.graphics.newQuad(x * 32, y * 32, 32, 32, gSheet:getDimensions())
        else
            gFrames['tiles'][sheetCounter - 9] =
                love.graphics.newQuad(x * 32, y * 32, 32, 32, gSheet:getDimensions())
        end
        sheetCounter = sheetCounter + 1
    end
end
