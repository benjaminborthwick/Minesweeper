PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.width = params.width
    self.height = params.height
    self.bombs = params.bombs
    self.tileMap = params.tileMap
    self.highScores = params.highScores
    self.difficulty = params.difficulty
    self.lost = false
end

function PlayState:update()
    -- if the mouse was clicked
    if #mousePress > 0 then
        --syncing mouse position with grid
        local mouseX = 1 + math.floor(mousePress[1] / 32)
        local mouseY = 1 + math.floor(mousePress[2] / 32)
        local mouseTile = (mouseY - 1) * self.width + mouseX

        -- if left click
        if mousePress[3] == 1 and not self.tileMap[mouseTile].flag then
            self:revealTile(self.tileMap[mouseTile])
        end

        -- if right click
        if mousePress[3] == 2 and self.tileMap[mouseTile].revealed == false then
            if not self.tileMap[mouseTile].flag then
                self.tileMap[mouseTile].flag = true
            else
                self.tileMap[mouseTile].flag = false
            end
        end

        -- check if game is over
        unclassified_tiles = false
        for k, tile in pairs(self.tileMap) do
            if not tile.revealed and not tile.flag then
                unclassified_tiles = true
            end
        end
        if not unclassified_tiles and not self.lost then
            gStateMachine:change('win', {
                width = self.width,
                height = self.height,
                bombs = self.bombs,
                tileMap = self.tileMap,
                highScores = self.highScores,
                time = math.floor(getTime()),
                difficulty = self.difficulty
            })
        end
    end
end

function PlayState:revealTile(tile)
    tile.revealed = true
    if tile.bomb then
        tile.exploded = true
        self.lost = true
        gStateMachine:change('lose', {
            width = self.width,
            height = self.height,
            bombs = self.bombs,
            tileMap = self.tileMap,
            highScores = self.highScores,
            time = math.floor(getTime()),
            difficulty = self.difficulty
        })
    elseif tile.number == 0 then
        for y = math.max(1, tile.y - 1), math.min(tile.y + 1, self.height) do
            for x = math.max(1, tile.x - 1), math.min(tile.x + 1, self.width) do
                if not self.tileMap[(y - 1) * self.width + x].revealed and not (y == tile.y and x == tile.x) then
                    self:revealTile(self.tileMap[(y - 1) * self.width + x])
                end
            end
        end
    end
end

function PlayState:exit()

end

function PlayState:render()
    for k, tile in pairs(self.tileMap) do
        tile:render()
    end
end