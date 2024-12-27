local UI = {}

-- Highlight selected card
local selectedCardIndex = nil

function UI:drawHand(player, x, y, isCurrentPlayer)
    for i, card in ipairs(player.hand) do
        local cardText = card.value .. " of " .. card.suit
        local cardY = y + (i - 1) * 20
        if isCurrentPlayer then
            love.graphics.setColor(0, 1, 0) -- Green color for the current player's hand
        else
            love.graphics.setColor(1, 1, 1) -- Default white color
        end
        love.graphics.print(cardText, x, cardY)
    end
end

function UI:drawGameState(game)
    -- Draw turn indicator
    local turnText = "Player " .. game.currentPlayer .. "'s Turn"
    love.graphics.setColor(1, 1, 0) -- Yellow color for the turn indicator
    love.graphics.print(turnText, 400, 10)

    -- Draw player stats
    love.graphics.setColor(1, 1, 1) -- Reset to white
    love.graphics.print("Player 1 Pairs: " .. game.player1.pairs, 10, 10)
    love.graphics.print("Player 2 Pairs: " .. game.player2.pairs, 300, 10)

    -- Draw feedback about the last turn (fallback to empty string if nil)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(game.feedback or "", 400, 30)

    -- Draw hands
    self:drawHand(game.player1, 10, 50, game.currentPlayer == 1)
    self:drawHand(game.player2, 300, 50, game.currentPlayer == 2)
end



-- Handle mouse clicks for selecting cards
function UI:mousePressed(x, y, game)
    if game.currentPlayer == 1 then
        for i = 1, #game.player1.hand do
            if y > 50 + (i - 1) * 20 and y < 70 + (i - 1) * 20 then
                selectedCardIndex = i
                return
            end
        end
    elseif game.currentPlayer == 2 then
        for i = 1, #game.player2.hand do
            if y > 50 + (i - 1) * 20 and y < 70 + (i - 1) * 20 then
                selectedCardIndex = i
                return
            end
        end
    end
end

function UI:getSelectedCard(game)
    if game.currentPlayer == 1 and selectedCardIndex then
        return game.player1.hand[selectedCardIndex]
    elseif game.currentPlayer == 2 and selectedCardIndex then
        return game.player2.hand[selectedCardIndex]
    end
    return nil
end

function UI:clearSelection()
    selectedCardIndex = nil
end

return UI
