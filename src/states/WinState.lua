WinState = Class{__includes = BaseState}

function WinState:enter(params)
    self.width = params.width
    self.height = params.height
    self.bombs = params.bombs
    self.tileMap = params.tileMap
    self.highScores = params.highScores
    self.time = params.time

    self:updateHighScores()
end

function WinState:update()
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            width = self.width,
            height = self.height,
            bombs = self.bombs,
            tileMap = MapMaker.generate(self.width, self.height, self.bombs),
            highScores = self.highScores
        })
    end
end

function WinState:exit() end

function WinState:updateHighScores()
    local highScore = false
    -- check to see if current score is higher than any high scores
    for i = 1, 10 do
        -- makse sure the high score hasn't already been set
        if self.time < self.highScores[i] and not highScore then
            -- shift all the scores beneath that one down by one slot
            for j = 10, i, -1 do
                self.highScores[j + 1] = self.highScores[j]
            end
            -- insert the new score into it's slot
            self.highScores[i] = self.time
            highScore = true
        end
    end

    scoreStr = ''
    for i = 1, 10 do
        scoreStr = scoreStr .. tostring(self.highScores[i]) .. '\n'
    end

    love.filesystem.write('minesweeper.lst', scoreStr)
end

function WinState:render() 
    for k, tile in pairs(self.tileMap) do
        tile:render()
    end
    love.graphics.setColor(255, 255, 255, 215)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 32 * 8 + 5, VIRTUAL_HEIGHT / 2 - 32 * 5 + 5, 32 * 16 - 10, 32 * 10 - 10)
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf('You Won!', 1, VIRTUAL_HEIGHT / 2 - 32 * 5 + 25, VIRTUAL_WIDTH, 'center')
    for i = 1, 5 do
        love.graphics.printf(tostring(self.highScores[i]), VIRTUAL_WIDTH / 2 - 32 * 8 + 100, VIRTUAL_HEIGHT / 2 - 32 * 5 + 40 + 40 * i, 200, 'left')
    end
    for i = 6, 10 do
        love.graphics.printf(tostring(self.highScores[i]), VIRTUAL_WIDTH / 2 - 32 * 8 + 340, VIRTUAL_HEIGHT / 2 - 32 * 5 + 40 + 40 * (i - 5), 200, 'left')
    end
end