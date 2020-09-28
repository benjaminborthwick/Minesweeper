MapMaker = Class{}

function MapMaker.generate(width, height, bombs)
    local tiles = {}
    local bombTiles = {}

    -- Finding the location of all the bombs as a number, 1 - # of tiles
    bombCounter = 1
    while bombCounter <= bombs do
        bombPlace = math.random(1, width*height)
        isBombCopy = false
        if #bombTiles > 0 then
            for k, bomb in pairs(bombTiles) do
                if bomb == bombPlace then
                    isBombCopy = true
                end
            end
        end
        if not isBombCopy then
            bombTiles[bombCounter] = bombPlace
            bombCounter = bombCounter + 1
        end
    end

    -- creating all of the tiles
    local tileCounter = 1
    for y = 1, height do
        for x = 1, width do
            tiles[tileCounter] = Tile(x, y)
            tileCounter = tileCounter + 1
        end
    end

    -- placing the bombs in the predetermined tiles
    for k, bombIndex in pairs(bombTiles) do
        tiles[bombIndex].bomb = true
    end

    return tiles
end

function MapMaker.tileBombCount(tiles, width, height)
    --counting bombs around each tile
    local bombCount
    for k, tile in pairs(tiles) do
        if not tile.bomb then
            bombCount = 0
            for y = math.max(1, tile.y - 1), math.min(tile.y + 1, height) do
                for x = math.max(1, tile.x - 1), math.min(tile.x + 1, width) do
                    if tiles[(y - 1) * width + x].bomb then
                        bombCount = bombCount + 1
                    end
                end
            end
            tile.number = bombCount
        end
    end
end


function MapMaker.makeSafeSpot(tiles, width, height, tilePlace)
    local bombsToReplace = 0
    local tileX = tilePlace % width
    local tileY = math.floor(tilePlace / width) + 1
    for y = math.max(1, tileY - 1), math.min(tileY + 1, height) do
        for x = math.max(1, tileX - 1), math.min(tileX + 1, width) do
            if tiles[(y - 1) * width + x].bomb then
                tiles[(y - 1) * width + x].bomb = false
                bombsToReplace = bombsToReplace + 1
            end
        end
    end
    while bombsToReplace > 0 do
        bombPlace = math.random(1, width*height)
        local bombX = bombPlace % width
        local bombY = math.floor(bombPlace / width) + 1
        if tiles[bombPlace].bomb -- If the tile is already a bomb
                or ((bombX >= tileX - 1 and bombX <= tileX + 1) -- the tile is in the x range of the circle of tiles surrounding the start tile
                and (bombY >= tileY - 1 and bombX <= tileY + 1)) then -- the tile is in the y range "   "    "    "
            -- do nothing because a bomb shouldn't go in that spot
        else
            -- place a bomb here
            tiles[bombPlace].bomb = true
            bombsToReplace = bombsToReplace - 1
        end
    end
end