
-- 閲覧、質問をしたいボードを選ばせる画面

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require "widget"

local _W = display.viewableContentWidth
local _H = display.viewableContentHeight

local DecideBtn
local function onDecideBtnRelease()
	composer.gotoScene( "boardMenuFromAsk", "fromBottom", 500 )
	return true
end

local back -- 前の画面に戻るボタン
local function onBackBtnRelease() -- ログインボタンを押された場合に板新設画面へ
	composer.gotoScene( "ask", "fromBottom", 500 )
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
	local bg = display.newRect( 0, 0, _W, _H ) -- 背景の設定
	bg.anchorX = 0 -- 背景の四角形の基準点のx座標
	bg.anchorY = 0 -- 背景の四角形の基準点のy座標
	bg:setFillColor( 1 )	-- 白

	local title = display.newText( "検索結果一覧 n件がヒットしました", 0, 0, native.systemFont, 14 ) -- ページ上部にタイトルを表示
	title:setFillColor( 0 )	-- 黒
	title.x = display.contentWidth * 0.5
	title.y = 70

	DecideBtn = widget.newButton{
		label = "○○説明会2016",
		labelColor = { default={255}, over={128} },
		defaultFile = "btn.png",
		overFile = "btnover.png",
		width = _W/3*2, height = _H/6,
		emboss = true,
		onRelease = onDecideBtnRelease	-- ボタンを押された際のファンクション呼び出し
	}

	DecideBtn.x = _W*0.5
	DecideBtn.y = _H /3 *2

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

	--ボタンを削除する
	if DecideBtn then
		DecideBtn:removeSelf()	-- widgets must be manually removed
		DecideBtn = nil
	end

  if back then
		back:removeSelf()	-- widgets must be manually removed
		back = nil
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
