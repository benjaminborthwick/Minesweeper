

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

    gStateMachine:change('start')

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

function resizeWindow(w, h)
    VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_HEIGHT, WINDOW_WIDTH =  w, h, w, h
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })
end

function getTime()
    return timer
end

function resetTimer()
    timer = 0
end

function loadHighScores(difficulty)
    love.filesystem.setIdentity('minesweeper')

    if difficulty == 1 then
        -- if the file doesn't exist, initialize it with some default scores
        if not love.filesystem.exists('minesweeper-easy.lst') then
            local scores = ''
            for i = 10, 1, -1 do
                scores = scores .. tostring(999) .. '\n'
            end

            love.filesystem.write('minesweeper-easy.lst', scores)
        end

        local counter = 1

        -- initialize scores table with at least 10 blank entries
        local scores = {}

        for i = 1, 10 do
            -- blank table; each will hold a score
            scores[i] = nil
        end

        -- iterate over each line in the file, filling in scores
        for line in love.filesystem.lines('minesweeper-easy.lst') do
            scores[counter] = tonumber(line)
            counter = counter + 1
        end

        return scores
    elseif difficulty == 2 then
        -- if the file doesn't exist, initialize it with some default scores
        if not love.filesystem.exists('minesweeper-normal.lst') then
            local scores = ''
            for i = 10, 1, -1 do
                scores = scores .. tostring(999) .. '\n'
            end

            love.filesystem.write('minesweeper-normal.lst', scores)
        end

        local counter = 1

        -- initialize scores table with at least 10 blank entries
        local scores = {}

        for i = 1, 10 do
            -- blank table; each will hold a score
            scores[i] = nil
        end

        -- iterate over each line in the file, filling in scores
        for line in love.filesystem.lines('minesweeper-normal.lst') do
            scores[counter] = tonumber(line)
            counter = counter + 1
        end

        return scores
    else
        -- if the file doesn't exist, initialize it with some default scores
        if not love.filesystem.exists('minesweeper-hard.lst') then
            local scores = ''
            for i = 10, 1, -1 do
                scores = scores .. tostring(999) .. '\n'
            end

            love.filesystem.write('minesweeper-hard.lst', scores)
        end

        local counter = 1

        -- initialize scores table with at least 10 blank entries
        local scores = {}

        for i = 1, 10 do
            -- blank table; each will hold a score
            scores[i] = nil
        end

        -- iterate over each line in the file, filling in scores
        for line in love.filesystem.lines('minesweeper-hard.lst') do
            scores[counter] = tonumber(line)
            counter = counter + 1
        end

        return scores
    end
end