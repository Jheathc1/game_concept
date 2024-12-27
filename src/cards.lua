local Card = {}

function Card:new(value, suit)
    local card = {
        value = value, -- e.g., "Ace", "2", ..., "King"
        suit = suit   -- e.g., "Hearts", "Spades"
    }
    setmetatable(card, self)
    self.__index = self
    return card
end

-- Function to create a full deck
function Card:createDeck()
    local suits = {"Hearts", "Spades", "Diamonds", "Clubs"}
    local values = {"Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"}
    local deck = {}

    for _, suit in ipairs(suits) do
        for _, value in ipairs(values) do
            table.insert(deck, Card:new(value, suit))
        end
    end
    return deck
end

-- Shuffle function
function Card:shuffle(deck)
    for i = #deck, 2, -1 do
        local j = math.random(i)
        deck[i], deck[j] = deck[j], deck[i]
    end
end

return Card
