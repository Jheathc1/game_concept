local UI = {}
local Card = require("src.cards")


-- Highlight selected card
local selectedCardIndex = nil


function UI:drawHand(player, baseX, baseY, isCurrentPlayer)
    local scale = 2.0
    local spacing = 100

    for i, card in ipairs(player.hand) do
        local cardX = baseX + (i - 1) * spacing
        local cardY = baseY

        -- Draw the card
        love.graphics.draw(card.image, cardX, cardY, 0, scale, scale)

        -- Highlight current player's cards with a green border
        if isCurrentPlayer then
            love.graphics.setColor(0, 1, 0) -- Green for the current player
            love.graphics.rectangle(
                "line",
                cardX,
                cardY,
                card.image:getWidth() * scale,
                card.image:getHeight() * scale
            )
            love.graphics.setColor(1, 1, 1) -- Reset color to white
        end

        -- Store clickable card regions
        card.clickRegion = {
            x = cardX,
            y = cardY,
            width = card.image:getWidth() * scale,
            height = card.image:getHeight() * scale
        }
    end
end



function UI:drawCompletedPairs(player, baseX, baseY)
    local scale = 2.0
    local pairSpacing = 120
    local overlap = 20

    for i, pair in ipairs(player.completedPairs) do
        if pair.cards and #pair.cards == 2 then
            local card1 = pair.cards[1]
            local card2 = pair.cards[2]

            if card1.image and card2.image then
                -- Draw the first card
                love.graphics.draw(card1.image, baseX + (i - 1) * pairSpacing, baseY, 0, scale, scale)
                -- Draw the second card slightly overlapping
                love.graphics.draw(card2.image, baseX + (i - 1) * pairSpacing + overlap, baseY + overlap, 0, scale, scale)
            else
                print("Warning: Missing images for pair", i)
            end
        else
            print("Warning: Invalid pair structure at index", i)
        end
    end
end






function UI:drawGameState(game)
    local screenWidth, screenHeight = love.graphics.getDimensions()

    -- Draw Player 1's hand and completed pairs
    love.graphics.print("Player 1", 10, 10)
    self:drawHand(game.player1, 10, 50, game.currentPlayer == 1)
    self:drawCompletedPairs(game.player1, 10, 200) -- Below Player 1's hand

    -- Draw Player 2's hand and completed pairs
    love.graphics.print("Player 2", 10, screenHeight - 150)
    self:drawHand(game.player2, 10, screenHeight - 100, game.currentPlayer == 2)
    self:drawCompletedPairs(game.player2, 10, screenHeight - 300) -- Above Player 2's hand

    -- Draw turn indicator
    local turnText = "Player " .. game.currentPlayer .. "'s Turn"
    love.graphics.setColor(1, 1, 0)
    love.graphics.print(turnText, screenWidth / 2 - 50, 10)
    love.graphics.setColor(1, 1, 1) -- Reset color
end






function UI:mousePressed(x, y, game)
    local currentPlayer = game.currentPlayer == 1 and game.player1 or game.player2
    local opponent = game.currentPlayer == 1 and game.player2 or game.player1

    -- Check if the player clicked one of their cards
    for _, card in ipairs(currentPlayer.hand) do
        local region = card.clickRegion
        if x >= region.x and x <= region.x + region.width and y >= region.y and y <= region.y + region.height then
            print("Selected card:", card.value, "of", card.suit)
            game:takeTurn(card.value)
            return
        end
    end

    print("No card selected")
end



function UI:getSelectedCard(game)
    if selectedCardIndex then
        local selectedCard
        if game.currentPlayer == 1 then
            selectedCard = game.player1.hand[selectedCardIndex]
        else
            selectedCard = game.player2.hand[selectedCardIndex]
        end
        print("Selected card:", selectedCard.value, "of", selectedCard.suit)
        return selectedCard
    end
    return nil
end



function UI:clearSelection()
    selectedCardIndex = nil
end

return UI
