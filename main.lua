local Card = require "src.cards"
local Game = require "src.game"
local UI = require "src.ui"

local game

function love.load()
    -- Initialize the game
    local cardModule = Card:new()
    local deck = cardModule:createDeck()
    cardModule:shuffle(deck)

    game = Game:new()
    game.deck = deck
    game:dealCards()
end

function love.update(dt)
    -- You could add timers or animations here later
end

function love.mousepressed(x, y, button)
    if button == 1 then -- Left mouse button
        UI:mousePressed(x, y, game)
        local selectedCard = UI:getSelectedCard(game)
        if selectedCard then
            game:takeTurn(selectedCard.value)
            UI:clearSelection()
        end
    end
end

function love.draw()
    UI:drawGameState(game)
end