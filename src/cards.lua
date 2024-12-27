local Card = {}

-- Value-to-index mapping
Card.valueMap = {
    ["Ace"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6,
    ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10, ["Jack"] = 11, ["Queen"] = 12, ["King"] = 13
}


function Card:loadAssets()
    self.images = {
        spades = {},
        hearts = {},
        diamonds = {},
        clubs = {},
        backs = {}
    }

    local function safeLoadImage(path)
        if love.filesystem.getInfo(path) then
            return love.graphics.newImage(path)
        else
            print("Warning: Could not find image at path:", path)
            return nil
        end
    end

    -- Load Spades
    for i = 1, 13 do
        local path = "assets/cards/Spades/Spades_card_" .. string.format("%02d", i) .. ".png"
        self.images.spades[i] = safeLoadImage(path)
    end

    -- Load Hearts
    for i = 1, 13 do
        local path = "assets/cards/Hearts/Hearts_card_" .. string.format("%02d", i) .. ".png"
        self.images.hearts[i] = safeLoadImage(path)
    end

    -- Load Diamonds
    for i = 1, 13 do
        local path = "assets/cards/Diamonds/Diamonds_card_" .. string.format("%02d", i) .. ".png"
        self.images.diamonds[i] = safeLoadImage(path)
    end

    -- Load Clubs
    for i = 1, 13 do
        local path = "assets/cards/Clubs/Clubs_card_" .. string.format("%02d", i) .. ".png"
        self.images.clubs[i] = safeLoadImage(path)
    end

    -- Load Card Backs
    for i = 0, 8 do -- Adjust for the naming convention
        local path = "assets/cards/Backs/back_" .. i .. ".png"
        self.images.backs[i + 1] = safeLoadImage(path) -- Store in 1-based Lua index
    end
end

-- Function to create a new card
function Card:new(value, suit, image)
    local card = {
        value = value, -- e.g., "Ace", "2", ..., "King"
        suit = suit,   -- e.g., "Hearts", "Spades"
        image = image  -- Corresponding image for the card
    }
    setmetatable(card, self)
    self.__index = self
    return card
end

function Card:createDeck()
    local suits = {"Hearts", "Spades", "Diamonds", "Clubs"}
    local values = {"Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"}
    local deck = {}

    for _, suit in ipairs(suits) do
        for valueIndex, value in ipairs(values) do
            local image
            if suit == "Hearts" then
                image = self.images.hearts[valueIndex]
            elseif suit == "Spades" then
                image = self.images.spades[valueIndex]
            elseif suit == "Diamonds" then
                image = self.images.diamonds[valueIndex]
            elseif suit == "Clubs" then
                image = self.images.clubs[valueIndex]
            end

            -- Debug: Print to ensure image is being assigned correctly
            if image then
                print("Assigned image for", value, "of", suit, ":", image)
            else
                print("No image found for", value, "of", suit)
            end

            table.insert(deck, Card:new(value, suit, image))
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
