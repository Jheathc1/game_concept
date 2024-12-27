local Game = {}

function Game:new()
    local game = {
        player1 = {hand = {}, pairs = 0},
        player2 = {hand = {}, pairs = 0},
        deck = {},
        currentPlayer = 1 -- Start with Player 1
    }
    setmetatable(game, self)
    self.__index = self
    return game
end

function Game:takeTurn(cardValue)
    local currentPlayer = self.currentPlayer == 1 and self.player1 or self.player2
    local opponent = self.currentPlayer == 1 and self.player2 or self.player1

    -- Check if the opponent has the requested card
    local found = false
    for i = #opponent.hand, 1, -1 do
        if opponent.hand[i].value == cardValue then
            table.insert(currentPlayer.hand, table.remove(opponent.hand, i))
            found = true
        end
    end

    if not found then
        -- Draw a card if no match
        if #self.deck > 0 then
            table.insert(currentPlayer.hand, table.remove(self.deck))
        end
    end

    -- Check for pairs
    self:checkPairs(currentPlayer)

    -- End turn and switch players
    if not found then
        self.currentPlayer = self.currentPlayer == 1 and 2 or 1
    end
end


-- Function to deal cards to players
function Game:dealCards()
    for _ = 1, 7 do
        table.insert(self.player1.hand, table.remove(self.deck))
        table.insert(self.player2.hand, table.remove(self.deck))
    end
end

-- Check for pairs in a player's hand
function Game:checkPairs(player)
    local hand = player.hand
    local pairs = {}
    local seen = {}

    for i, card in ipairs(hand) do
        if seen[card.value] then
            table.insert(pairs, card.value)
        else
            seen[card.value] = true
        end
    end

    -- Remove paired cards from hand
    for _, pair in ipairs(pairs) do
        for i = #hand, 1, -1 do
            if hand[i].value == pair then
                table.remove(hand, i)
            end
        end
    end

    player.pairs = player.pairs + #pairs
end

return Game
