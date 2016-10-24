-- スプラッシュ画面

-- ライブラリ
local composer = require( "composer" )
local scene = composer.newScene()
local json = require "json" -- test
local http = require("socket.http") -- test

-- 定数
local _W = display.viewableContentWidth
local _H = display.viewableContentHeight
userInfo = {}

-- オブジェクト
local bg, logo

--local inivitation_data = http.request("https://questionboard.herokuapp.com/users/show/kawase-y") -- test
--local invitations = json.decode(inivitation_data) -- test
--local getNum = invitations["name"] -- text
--local testData = display.newText( getNum, 50, 50, native.systemFont, 32 ) -- test
--testData:setTextColor(0,0,0)

bg    = display.newRect(0,0, _W, _H)
bg.x  = _W/2
bg.y  = _H/2
bg:setFillColor( 1, 1, 1 )

logo    = display.newImage("Splash.png", 10, 20)
logo.x  = _W/2
logo.y  = _H/2 + 50


-- スプラッシュを閉じる
local function closeSplash()

    display.remove(logo)
    display.remove(bg)
    logo        = nil
    background  = nil

    composer.gotoScene( "login", "fade", 2000  )
end

timer.performWithDelay(2000, closeSplash)
