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
    -- check to see if current score is higher than any high scores
    for i = 1, 10 do
        if self.time < self.highScores[i] then
            -- shift all the scores beneath that one down by one slot
            for j = 10, i, -1 do
                self.highScores[j + 1] = self.highScores[j]
            end
            self.highScores[i] = self.time
        end
    end

    scoreStr = ''
    for i = 1, 10 do
        scoreStr = scoreStr .. tostring(self.highScores[i]) .. '\n'
    end

    love.filesystem.write('minesweeper.lst', scoreStr)
end

function WinState:render() 
    --for k, tile in pairs(self.tileMap) do
    --    tile:render()
    --end
end