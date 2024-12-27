local Game = {}
local Card = require("src.cards")


function Game:new()
    local game = {
        player1 = {hand = {}, pairs = 0, completedPairs = {}},
        player2 = {hand = {}, pairs = 0, completedPairs = {}},
        deck = {}, -- The deck to draw cards from
        currentPlayer = 1, -- Start with Player 1
        feedback = "Game started!"
    }
    setmetatable(game, self)
    self.__index = self
    return game
end


function Game:dealCards()
    for _ = 1, 7 do
        local card1 = table.remove(self.deck)
        local card2 = table.remove(self.deck)

        if card1 then
            print("Dealt to Player 1:", card1.value, "of", card1.suit)
            table.insert(self.player1.hand, card1)
        end
        if card2 then
            print("Dealt to Player 2:", card2.value, "of", card2.suit)
            table.insert(self.player2.hand, card2)
        end
    end
end


function Game:takeTurn(cardValue)
    local currentPlayer = self.currentPlayer == 1 and self.player1 or self.player2
    local opponent = self.currentPlayer == 1 and self.player2 or self.player1

    print("Player " .. self.currentPlayer .. " is taking a turn. Asking for:", cardValue)

    -- Step 1: Check for a pair in the player's own hand
    local foundPairInHand = false
    local matchedCards = {}

    for _, card in ipairs(currentPlayer.hand) do
        if card.value == cardValue then
            table.insert(matchedCards, card)
            if #matchedCards == 2 then
                -- Add the pair to completed pairs
                table.insert(currentPlayer.completedPairs, {
                    value = cardValue,
                    cards = {matchedCards[1], matchedCards[2]}
                })
                currentPlayer.pairs = currentPlayer.pairs + 1
                self.feedback = "Player " .. self.currentPlayer .. " played a pair of " .. cardValue .. "!"
                print(self.feedback)

                -- Remove the paired cards from the hand
                for _, pairedCard in ipairs(matchedCards) do
                    for i = #currentPlayer.hand, 1, -1 do
                        if currentPlayer.hand[i] == pairedCard then
                            table.remove(currentPlayer.hand, i)
                            break
                        end
                    end
                end

                foundPairInHand = true
                break
            end
        end
    end

    if foundPairInHand then
        -- Check for win condition and pass the turn
        if currentPlayer.pairs >= 5 then
            self.feedback = "Player " .. self.currentPlayer .. " wins with 5 pairs!"
            print("Player " .. self.currentPlayer .. " wins!")
            return
        end
        self.currentPlayer = self.currentPlayer == 1 and 2 or 1
        return
    end

    -- Step 2: Ask the opponent for the card
    for i = #opponent.hand, 1, -1 do
        if opponent.hand[i].value == cardValue then
            -- Transfer the card to the current player
            local opponentCard = table.remove(opponent.hand, i)
            local selectedCard

            -- Find the selected card in the player's hand
            for j = #currentPlayer.hand, 1, -1 do
                if currentPlayer.hand[j].value == cardValue then
                    selectedCard = table.remove(currentPlayer.hand, j)
                    break
                end
            end

            -- Add the pair to completed pairs
            if selectedCard then
                table.insert(currentPlayer.completedPairs, {
                    value = cardValue,
                    cards = {selectedCard, opponentCard}
                })
                currentPlayer.pairs = currentPlayer.pairs + 1
                self.feedback = "Player " .. self.currentPlayer .. " got a card from Player " .. (self.currentPlayer == 1 and 2 or 1) .. " and played a pair of " .. cardValue .. "!"
                print(self.feedback)

                -- Check for win condition and pass the turn
                if currentPlayer.pairs >= 5 then
                    self.feedback = "Player " .. self.currentPlayer .. " wins with 5 pairs!"
                    print("Player " .. self.currentPlayer .. " wins!")
                    return
                end
                self.currentPlayer = self.currentPlayer == 1 and 2 or 1
                return
            end
        end
    end

    -- Step 3: Draw a card if no match found
    if #self.deck > 0 then
        local drawnCard = table.remove(self.deck)
        table.insert(currentPlayer.hand, drawnCard)
        self.feedback = "Player " .. self.currentPlayer .. " drew a card."
        print("Player " .. self.currentPlayer .. " drew:", drawnCard.value, "of", drawnCard.suit)
    else
        self.feedback = "Deck is empty!"
        print("The deck is empty.")
    end

    -- Pass the turn
    self.currentPlayer = self.currentPlayer == 1 and 2 or 1
    print("Turn switched to Player " .. self.currentPlayer)
end



function Game:addPair(player, card1, card2)
    -- Ensure both cards have all necessary properties
    if card1 and card2 and card1.image and card2.image then
        table.insert(player.completedPairs, {
            value = card1.value,
            cards = {card1, card2}
        })

        -- Remove the paired cards from the player's hand
        for i = #player.hand, 1, -1 do
            if player.hand[i] == card1 or player.hand[i] == card2 then
                table.remove(player.hand, i)
            end
        end

        player.pairs = player.pairs + 1
        print("Added pair:", card1.value, "of", card1.suit, "and", card2.value, "of", card2.suit)
    else
        print("Failed to add pair: Missing valid cards or images.")
    end
end



function Game:checkPairs(player)
    local hand = player.hand
    local seen = {}

    print("Checking for pairs in Player " .. (self.currentPlayer == 1 and 1 or 2) .. "'s hand")

    for i, card in ipairs(hand) do
        if seen[card.value] then
            -- Find the matching card
            local match = seen[card.value]
            self:addPair(player, match, card)
            return -- Exit after playing one pair
        else
            seen[card.value] = card
        end
    end

    print("No pairs found.")
end







return Game
