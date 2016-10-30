-- ボードの作成または質問を行うことを選択させるトップ画面

-- ライブラリ
local composer = require( "composer" )
local widget = require "widget"
local mui = require( "materialui.mui" )

-- 定数
local _W = display.viewableContentWidth
local _H = display.viewableContentHeight

-- オブジェクト
local scene = composer.newScene()

local bg					--背景

-- "質問をする"が押された場合は板検索画面へ
local function onAskBtnRelease()
	composer.gotoScene( "ask", "crossFade", 500 )
	return true
end

-- ”質問板作成”が押された場合はログイン画面へ
local function onBoardBtnRelease()
	composer.gotoScene( "userBoardIndex", "crossFade", 500 )
	return true
end

function scene:create( event )
	local sceneGroup = self.view

	--背景設定
	bg 					= display.newRect( 0, 0, _W, _H )
	bg.anchorX 	= 0
	bg.anchorY 	= 0
	bg:setFillColor( 1 )

	sceneGroup:insert( bg )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
	elseif phase == "did" then

		mui.init()

		mui.newNavbar({
		  name             = "navbar",
			height           = mui.getScaleVal(100),
    	left             = 0,
		  top              = 0,
		  fillColor        = { 0.63, 0.81, 0.181 },
			activeTextColor  = { 1, 1, 1, 1 },
    	padding          = mui.getScaleVal(50),
		})

		navTextOps = {
			x         = mui.getScaleVal(0),
			y         = mui.getScaleVal(0),
			name      = "nav-text",
			text      = "Top",
			align     = "center",
			width     = mui.getScaleVal(130),
			height    = mui.getScaleVal(50),
			font      = native.systemFontBold,
			fontSize  = mui.getScaleVal(40),
			fillColor = { 1, 1, 1, 1 },
		}
		mui.newText(navTextOps)

		mui.attachToNavBar( "navbar", {
			widgetName = "nav-text",
			widgetType = "Text",
			align      = "left"
		})

		-- タイトルText設定
    titleTextOps = {
      y         = 85,
      x         = _W / 2,
      name      = "title-text",
      text      = "QuestionBoard",
      align     = "center",
      width     = 400,
      font      = native.systemFontBold,
      fontSize  = mui.getScaleVal(64),
      fillColor = { 0, 0, 0, 1 },
    }
    mui.newText(titleTextOps)

		userTextOps = {
			y         = 130,
			x         = _W / 2,
			name      = "user-text",
			text      = "ようこそ"..userInfo["uId"].."さん",
			align     = "center",
			width     = 400,
			font      = native.systemFontBold,
			fontSize  = mui.getScaleVal(32),
			fillColor = { 0, 0, 0, 1 },
		}
		mui.newText(userTextOps)

		descTextOps = {
      y         = 200,
      x         = _W / 2,
      name      = "descText",
      text      = "アプリの謳い文句など\n◯◯な方は「質問をする」ボタンを\n◯◯な方は「質問板を作る」ボタン",
      align     = "center",
      width     = 350,
      font      = native.systemFont,
      fontSize  = mui.getScaleVal(24),
      fillColor = { 0, 0, 0, 1 },
    }
    mui.newText(descTextOps)

		-- ボタン
    mui.newRoundedRectButton({
    	name       = "ask-btn",
    	text       = "質問をする",
    	width      = mui.getScaleVal(400),
    	height     = mui.getScaleVal(80),
    	radius     = mui.getScaleVal(10),
    	x          = _W * 0.5,
    	y          = _H / 3 * 2,
    	font       = native.systemFont,
    	fillColor  = { 0.63, 0.81, 0.181, 1 },
    	textColor  = { 1, 1, 1 },
    	touchpoint = true,
    	callBack   = onAskBtnRelease
    })

		-- ボタン
		mui.newRoundedRectButton({
			name       = "board-btn",
			text       = "質問板を作る",
			width      = mui.getScaleVal(400),
			height     = mui.getScaleVal(80),
			radius     = mui.getScaleVal(10),
			x          = _W * 0.5,
			y          = _H / 3 * 2 + 50,
			font       = native.systemFont,
			fillColor  = { 0.63, 0.81, 0.181, 1 },
			textColor  = { 1, 1, 1 },
			touchpoint = true,
			callBack   = onBoardBtnRelease
		})

	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		mui.destroy()
	elseif phase == "did" then

	end
end

function scene:destroy( event )
	local sceneGroup = self.view



end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
