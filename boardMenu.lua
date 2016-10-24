-- 回答者(企業側)が掲示板を確認する画面

-- ライブラリ
local composer 	= require( "composer" )
local widget 		= require "widget"

-- 定数
local _W = display.viewableContentWidth
local _H = display.viewableContentHeight

-- オブジェクト
local scene = composer.newScene()

local bg 					-- 背景
local title 			-- タイトル

local boardName 	-- ”ボード名”テキスト

local backBtn 		-- 前の画面に戻るボタン


-- ログインボタンを押された場合に板新設画面へ
local function onBackBtnRelease()
	composer.gotoScene( "makeBoard", "fromBottom", 500 )
	return true
end


function scene:create( event )
	local sceneGroup = self.view

	-- 背景設定
	bg 					= display.newImage( "CorkBoard.jpg", 0, 0 )
	bg.anchorX 	= 0
	bg.anchorY 	= 0

	-- タイトル設定
	title 						= display.newRect(_W/2, 70,_W * 0.5,40 )
  title.strokeWidth = 3
	title:setFillColor( 1 )
  title:setStrokeColor( 0 )

	-- テキスト設定
  boardName = display.newText( "ボード名", _W/2, 72, native.systemFont, 32 )
  boardName:setTextColor(0,0,0)

	-- ボタン設定
	backBtn = widget.newButton{
		defaultFile 			= "imgs/apps/back-before.png",
		overFile 					= "imgs/apps/back.png",
		width 						= 50,
		height 						= 50,
		emboss 						= true,
		onRelease 				= onBackBtnRelease
	}
		backBtn.anchorX 	= 0
		backBtn.anchorY 	= 0
		backBtn.x 				= 0
		backBtn.y 				= 0

	sceneGroup:insert( bg )
	sceneGroup:insert( title )
  sceneGroup:insert( boardName )
	sceneGroup:insert( backBtn )

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
