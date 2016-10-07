-- 回答者(企業側)が掲示板を確認する画面

-- ライブラリ
local composer 	= require( "composer" )
local widget 		= require "widget"

-- 定数
local _W = display.viewableContentWidth
local _H = display.viewableContentHeight

-- オブジェクト
local scene = composer.newScene()

local bg 				-- 背景
local title 		-- タイトル

local boardName -- テキスト

local back 			-- 前の画面に戻るボタン
local askBtn 		-- 質問入力画面へ進むボタン

-- 質問入力画面へ進む
local function onAskBtnRelease()
	composer.gotoScene( "question", "fromBottom", 500 )
	return true
end

-- 検索結果画面へ戻る
local function onBackBtnRelease()
	composer.gotoScene( "searchResult", "fromBottom", 500 )
	return true
end

function scene:create( event )
	local sceneGroup = self.view

	-- 背景設定
  bg 					= display.newImage( "CorkBoard.jpg", 0, 0 )
	bg.anchorX 	= 0
	bg.anchorY 	= 0

	-- タイトル設定
	title = display.newRect(_W/2, 70,_W * 0.5,40 )
	title.strokeWidth = 3
	title:setStrokeColor( 0 )
	title:setFillColor( 1 )


	-- テキスト設定
  boardName = display.newText( "ボード名", _W/2, 72, native.systemFont, 32 )
  boardName:setTextColor(0,0,0)

	-- ボタン設定
	back = widget.newButton{
		defaultFile 	= "back-before.png",
		overFile 			= "back.png",
		width 				= 50,
		height 				= 50,
		emboss 				= true,
		onRelease 		= onBackBtnRelease
	}
	back.anchorX 		= 0
	back.anchorY 		= 0
	back.x 					= 0
	back.y 					= 0

	askBtn = widget.newButton{
	  defaultFile 	= "ask.png",
	  overFile		 	= "ask.png",
	  width 				= 50,
		height 				= 50,
	  emboss 				= true,
		onRelease 		= onAskBtnRelease
	}
	askBtn.anchorX 	= 0
	askBtn.anchorY 	= 0
	askBtn.x 				= _W - 50
	askBtn.y 				= _H - 50

	sceneGroup:insert( bg )
	sceneGroup:insert( title )
  sceneGroup:insert( boardName )
	sceneGroup:insert( back )
	sceneGroup:insert( askBtn )

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

  if boardName then
    boardName:removeSelf()	-- widgets must be manually removed
    boardName = nil
  end

	if askBtn then
		askBtn:removeSelf()	-- widgets must be manually removed
		askBtn = nil
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
