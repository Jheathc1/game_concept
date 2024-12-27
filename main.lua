local Card = require "src.cards"
local Game = require "src.game"
local UI = require "src.ui"

-- Combined animation variables
local waveParticles = {}
local maxParticles = 1000
local animationSpeed = 1.5
local centerX, centerY = 400, 300

local game
local cardModule

function love.load()
    love.window.setMode(0, 0, {fullscreen = true, resizable = true})
    -- card assets
    cardModule = Card
    cardModule:loadAssets()

    -- Initialize the game
    local deck = cardModule:createDeck()
    cardModule:shuffle(deck)

    game = Game:new()
    game.deck = deck
    game:dealCards()
end

function love.update(dt)
    for _, particle in ipairs(waveParticles) do
        particle.angle = particle.angle + particle.speed * dt * animationSpeed
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        UI:mousePressed(x, y, game)
        local selectedCard = UI:getSelectedCard(game)
        if selectedCard then
            game:takeTurn(selectedCard.value)
            UI:clearSelection()
        end
    end
end

function love.draw()
    drawGradientBackground()

    for _, particle in ipairs(waveParticles) do
        local x = centerX + math.cos(particle.angle) * particle.radius
        local y = centerY + math.sin(particle.angle) * particle.radius

        love.graphics.setColor(particle.color)
        love.graphics.circle("fill", x, y, particle.size)
    end

    love.graphics.setColor(1, 1, 1)

    UI:drawGameState(game)
end

function drawGradientBackground()
    local topColor = {0.4, 0, 0.6}
    local bottomColor = {0.8, 0.4, 1}
    local gradientSteps = 100
    local screenWidth, screenHeight = love.graphics.getDimensions()
    for i = 0, gradientSteps do
        local t = i / gradientSteps
        local r = topColor[1] * (1 - t) + bottomColor[1] * t
        local g = topColor[2] * (1 - t) + bottomColor[2] * t
        local b = topColor[3] * (1 - t) + bottomColor[3] * t
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle("fill", 0, t * screenHeight, screenWidth, screenHeight / gradientSteps)
    end
end
