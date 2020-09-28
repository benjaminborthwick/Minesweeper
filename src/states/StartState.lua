StartState = Class{__includes = BaseState}

function StartState:enter(params)
    self.selected = 3
end

function StartState:update(dt)
    if love.keyboard.wasPressed('left') then
        self.selected = (self.selected - 1) % 3
    elseif love.keyboard.wasPressed('right') then
        self.selected = (self.selected + 1) % 3
    end
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        resizeWindow(gDifficulty[self.selected].width * 32, gDifficulty[self.selected].height * 32)
        gStateMachine:change('play', {
            width = gDifficulty[self.selected].width,
            height = gDifficulty[self.selected].height,
            bombs = gDifficulty[self.selected].bombs,
            tileMap = MapMaker.generate(gDifficulty[self.selected].width, gDifficulty[self.selected].height, gDifficulty[self.selected].bombs),
            highScores = loadHighScores(self.selected),
            difficulty = self.selected
        })
    end
end

function StartState:render()
    for y = 1, 16 do
        for x = 1, 30 do
            love.graphics.draw(gSheet, gFrames['tiles'][1], (x - 1) * 32, (y - 1) * 32)
        end
    end
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf('Select a difficulty and press enter to begin', 1, 96, VIRTUAL_WIDTH, 'center')
    
    if self.selected == 1 then
        love.graphics.setColor(232, 232, 0)
        love.graphics.printf('Easy', 1, 384, 360, 'center')
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf('Normal', 1, 384, 960, 'center')
        love.graphics.printf('Hard', 1, 384, 1560, 'center')
    elseif self.selected == 2 then
        love.graphics.printf('Easy', 1, 384, 360, 'center')
        love.graphics.setColor(232, 232, 0)
        love.graphics.printf('Normal', 1, 384, 960, 'center')
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf('Hard', 1, 384, 1560, 'center')
    else
        love.graphics.printf('Easy', 1, 384, 360, 'center')
        love.graphics.printf('Normal', 1, 384, 960, 'center')
        love.graphics.setColor(245, 245, 0)
        love.graphics.printf('Hard', 1, 384, 1560, 'center')
    end
end

function StartState:exit() end