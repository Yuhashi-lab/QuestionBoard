-- ボードの作成または質問を行うことを選択させるトップ画面

-- ライブラリ
local composer = require( "composer" )
local widget = require "widget"

-- 定数
local _W = display.viewableContentWidth
local _H = display.viewableContentHeight

-- オブジェクト
local scene = composer.newScene()

local bg					--背景
local title				--タイトルテキスト

local AskBtn			--"質問をする"ボタン
local LoginBtn		--"質問版作成"ボタン

-- "質問をする"が押された場合は板検索画面へ
local function onAskBtnRelease()
	composer.gotoScene( "ask", "crossFade", 500 )
	return true
end

-- ”質問板作成”が押された場合はログイン画面へ
local function onLoginBtnRelease()
	composer.gotoScene( "login", "crossFade", 500 )
	return true
end

function scene:create( event )
	local sceneGroup = self.view

	--背景設定
	bg 					= display.newRect( 0, 0, _W, _H )
	bg.anchorX 	= 0
	bg.anchorY 	= 0
	bg:setFillColor( 1 )

	--タイトル設定
	title 	= display.newText( "Question Board", 0, 0, native.systemFont, 32 )
	title.x = display.contentWidth * 0.5
	title.y = 70
	title:setFillColor( 0 )

	--ボタン設定
	AskBtn = widget.newButton{
		label 			= "質問をする",
		labelColor 	= { default={255}, over={128} },
		defaultFile = "btn.png",
		overFile 		= "btnover.png",
		width 			= _W/3*2,
		height 			= _H/6,
		emboss 			= true,
		onRelease 	= onAskBtnRelease
	}
	AskBtn.x 			= _W * 0.5
	AskBtn.y 			= _H /3 + 50

	LoginBtn = widget.newButton{
		label 			= "質問板作成",
		labelColor 	= { default={255}, over={128} },
		defaultFile = "btn.png",
		overFile 		= "btnover.png",
		width 			= _W/3*2,
		height 			= _H/6,
		emboss 			= true,
		onRelease 	= onLoginBtnRelease
	}
	LoginBtn.x 		= _W * 0.5
	LoginBtn.y 		= _H / 3 * 2

	sceneGroup:insert( bg )
	sceneGroup:insert( title )
	sceneGroup:insert( LoginBtn )
	sceneGroup:insert( AskBtn )

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

	--ボタンを削除する
	if LoginBtn then
		LoginBtn:removeSelf()	-- widgets must be manually removed
		LoginBtn = nil
	end

	if AskBtn then
		AskBtn:removeSelf()	-- widgets must be manually removed
		AskBtn = nil
	end

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
