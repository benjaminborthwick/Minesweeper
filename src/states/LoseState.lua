LoseState = Class{__includes = BaseState}

function LoseState:enter(params)
    self.width = params.width
    self.height = params.height
    self.bombs = params.bombs
    self.tileMap = params.tileMap
    self.highScores = params.highScores
    self.time = params.time
    self.difficulty = params.difficulty

    for k, tile in pairs(self.tileMap) do
        tile.revealed = true
    end
end

function LoseState:update(params)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            width = self.width,
            height = self.height,
            bombs = self.bombs,
            tileMap = MapMaker.generate(self.width, self.height, self.bombs),
            highScores = self.highScores,
            difficulty = self.difficulty
        })
    end
end

function LoseState:exit() end

function LoseState:render()
    for k, tile in pairs(self.tileMap) do
        tile:render()
    end
    if self.difficulty == 1 then
        love.graphics.setColor(255, 255, 255, 215)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 32 * 4 + 5, VIRTUAL_HEIGHT / 2 - 32 * 4 + 5, 32 * 8 - 10, 32 * 8 - 10)
        love.graphics.setFont(gFonts['small'])
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf('You Lost', 1, VIRTUAL_HEIGHT / 2 - 32 * 5 + 40, VIRTUAL_WIDTH, 'center')
        for i = 1, 5 do
            love.graphics.printf(tostring(self.highScores[i]), VIRTUAL_WIDTH / 2 - 32 * 8 + 160, VIRTUAL_HEIGHT / 2 - 32 * 5 + 40 + 40 * i, 200, 'left')
        end
        for i = 6, 10 do
            love.graphics.printf(tostring(self.highScores[i]), VIRTUAL_WIDTH / 2 - 32 * 8 + 280, VIRTUAL_HEIGHT / 2 - 32 * 5 + 40 + 40 * (i - 5), 200, 'left')
        end
    elseif self.difficulty == 2 then
        love.graphics.setColor(255, 255, 255, 215)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 32 * 5 + 5, VIRTUAL_HEIGHT / 2 - 32 * 5 + 5, 32 * 10 - 10, 32 * 10 - 10)
        love.graphics.setFont(gFonts['small'])
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf('You Lost', 1, VIRTUAL_HEIGHT / 2 - 32 * 5 + 25, VIRTUAL_WIDTH, 'center')
        for i = 1, 5 do
            love.graphics.printf(tostring(self.highScores[i]), VIRTUAL_WIDTH / 2 - 32 * 8 + 140, VIRTUAL_HEIGHT / 2 - 32 * 5 + 40 + 40 * i, 200, 'left')
        end
        for i = 6, 10 do
            love.graphics.printf(tostring(self.highScores[i]), VIRTUAL_WIDTH / 2 - 32 * 8 + 300, VIRTUAL_HEIGHT / 2 - 32 * 5 + 40 + 40 * (i - 5), 200, 'left')
        end
    else
        love.graphics.setColor(255, 255, 255, 215)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 32 * 8 + 5, VIRTUAL_HEIGHT / 2 - 32 * 5 + 5, 32 * 16 - 10, 32 * 10 - 10)
        love.graphics.setFont(gFonts['small'])
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf('You Lost', 1, VIRTUAL_HEIGHT / 2 - 32 * 5 + 25, VIRTUAL_WIDTH, 'center')
        for i = 1, 5 do
            love.graphics.printf(tostring(self.highScores[i]), VIRTUAL_WIDTH / 2 - 32 * 8 + 100, VIRTUAL_HEIGHT / 2 - 32 * 5 + 40 + 40 * i, 200, 'left')
        end
        for i = 6, 10 do
            love.graphics.printf(tostring(self.highScores[i]), VIRTUAL_WIDTH / 2 - 32 * 8 + 340, VIRTUAL_HEIGHT / 2 - 32 * 5 + 40 + 40 * (i - 5), 200, 'left')
        end
    end
end