-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
composer.gotoScene( "top", "fade", 2000  )

local _W = display.viewableContentWidth
local _H = display.viewableContentHeight

local background = display.newRect(0,0, _W, _H)
background:setFillColor( 1, 1, 1 )
background.x = _W/2
background.y = _H/2


local logo = display.newImage("Splash.png", 10, 20)
logo.x = _W/2
logo.y = _H/2 + 50


-- スプラッシュを閉じる

local function closeSplash()

    display.remove(logo)
    logo = nil
    display.remove(background)
    background = nil
end

timer.performWithDelay(2000, closeSplash)
