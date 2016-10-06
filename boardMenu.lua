-- 回答者(企業側)が掲示板を確認する画面

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require "widget"

local _W = display.viewableContentWidth -- 画面の幅の取得
local _H = display.viewableContentHeight -- 画面の高さの取得

local back -- 前の画面に戻るボタン
local function onBackBtnRelease() -- ログインボタンを押された場合に板新設画面へ
	composer.gotoScene( "makeBoard", "fromBottom", 500 )
	return true
end
back = widget.newButton{
	defaultFile = "back-before.png",
	overFile = "back.png",
	width = 50, height = 50,
	emboss = true,
	onRelease = onBackBtnRelease	-- ボタンを押された際のファンクション呼び出し
}
	back.anchorX = 0 -- 基準点のx座標
	back.anchorY = 0 -- 基準点のy座標
	back.x = 0
	back.y = 0

function scene:create( event )
	local sceneGroup = self.view
  local bg = display.newImage( "CorkBoard.jpg", 0, 0 ) -- 背景の設定
	bg.anchorX = 0 -- 背景の四角形の基準点のx座標
	bg.anchorY = 0 -- 背景の四角形の基準点のy座標

	local title = display.newRect(_W/2, 70,_W * 0.5,40 ) -- ページ上部にタイトルを表示
	title:setFillColor( 1 )	-- 白
  title.strokeWidth = 3
  title:setStrokeColor( 0 )


  local boardName = display.newText( "ボード名", _W/2, 72, native.systemFont, 32 )
  boardName:setTextColor(0,0,0)


	sceneGroup:insert( bg )
	sceneGroup:insert( title )
  sceneGroup:insert( boardName )
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

  if boardName then
    boardName:removeSelf()	-- widgets must be manually removed
    boardName = nil
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
