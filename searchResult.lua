-- 閲覧、質問をしたいボードを選ばせる画面

local composer = require( "composer" )

local widget = require "widget"

-- 定数
local _W = display.viewableContentWidth
local _H = display.viewableContentHeight

-- オブジェクト
local scene = composer.newScene()

local bg					-- 背景
local title				-- タイトル

local DecideBtn		-- 質問板遷移用ボタン
local back 				-- 前の画面に戻るボタン

-- 質問板が押されたらその板の画面へ
local function onDecideBtnRelease()
	composer.gotoScene( "boardMenuFromAsk", "fromBottom", 500 )
	return true
end

-- 戻るボタンが押されたら検索画面へ
local function onBackBtnRelease()
	composer.gotoScene( "ask", "fromBottom", 500 )
	return true
end

function scene:create( event )
	local sceneGroup = self.view

	-- 背景設定
	bg 					= display.newRect( 0, 0, _W, _H )
	bg.anchorX 	= 0
	bg.anchorY 	= 0
	bg:setFillColor( 1 )

	--タイトル設定
	title 	= display.newText( "検索結果一覧 n件がヒットしました", 0, 0, native.systemFont, 14 ) -- ページ上部にタイトルを表示
	title.x = display.contentWidth * 0.5
	title.y = 70
	title:setFillColor( 0 )

	-- ボタン設定
	DecideBtn = widget.newButton{
		label 			= "○○説明会2016",
		labelColor 	= { default={255}, over={128} },
		defaultFile = "imgs/apps/btn.png",
		overFile 		= "imgs/apps/btnover.png",
		width 			= _W/3*2,
		height 			= _H/6,
		emboss 			= true,
		onRelease 	= onDecideBtnRelease
	}
	DecideBtn.x 	= _W*0.5
	DecideBtn.y 	= _H /3 *2

	back = widget.newButton{
		defaultFile 	= "imgs/apps/back-before.png",
		overFile 			= "imgs/apps/back.png",
		width 				= 50,
		height 				= 50,
		emboss 				= true,
		onRelease 		= onBackBtnRelease
	}
		back.anchorX 	= 0
		back.anchorY 	= 0
		back.x 				= 0
		back.y 				= 0

	sceneGroup:insert( bg )
	sceneGroup:insert( title )
	sceneGroup:insert( DecideBtn )
	sceneGroup:insert( back )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
	elseif phase == "did" then

	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

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
