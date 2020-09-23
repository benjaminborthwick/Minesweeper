LoseState = Class{__includes = BaseState}

function LoseState:enter(params)
    self.width = params.width
    self.height = params.height
    self.bombs = params.bombs
    self.tileMap = params.tileMap
    self.highScores = params.highScores
    self.time = params.time

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
            highScores = self.highScores
        })
    end
end

function LoseState:exit() end

function LoseState:render()
    for k, tile in pairs(self.tileMap) do
        tile:render()
    end
    love.graphics.setColor(255, 255, 255, 215)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 32 * 8 + 5, VIRTUAL_HEIGHT / 2 - 32 * 5 + 5, 32 * 16 - 10, 32 * 10 - 10)
end