

require 'src/Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Minesweeper')

    math.randomseed(os.time())

    timer = 0

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['lose'] = function() return LoseState() end,
        ['win'] = function() return WinState() end
    }

    gStateMachine:change('start', {
        highScores = loadHighScores()
    })

    mousePress = {}

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mousepressed(x, y, button, isTouch)
    mousePress = {x, y, button}
end

function love.update(dt)
    gStateMachine:update(dt)
    mousePress = {}
    love.keyboard.keysPressed = {}

    timer = timer + dt
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end

function getTime()
    return timer
end

function loadHighScores()
    love.filesystem.setIdentity('minesweeper')

    -- if the file doesn't exist, initialize it with some default scores
    if not love.filesystem.exists('minesweeper.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. tostring(999) .. '\n'
        end

        love.filesystem.write('minesweeper.lst', scores)
    end

    local counter = 1

    -- initialize scores table with at least 10 blank entries
    local scores = {}

    for i = 1, 10 do
        -- blank table; each will hold a score
        scores[i] = nil
    end

    -- iterate over each line in the file, filling in scores
    for line in love.filesystem.lines('minesweeper.lst') do
        scores[counter] = tonumber(line)
        counter = counter + 1
    end

    return scores
end