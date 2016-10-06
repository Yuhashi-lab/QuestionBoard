-- 回答者(企業側)が掲示板を作成する画面

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require "widget"

local _W = display.viewableContentWidth -- 画面の幅の取得
local _H = display.viewableContentHeight -- 画面の高さの取得

local makeBtn -- ""ログイン""と書かれたボタン
local function onMakeBtnBtnRelease() -- ログインボタンを押された場合に板新設画面へ
	composer.gotoScene( "boardMenu", "fromBottom", 500 )
	return true
end

local back -- 前の画面に戻るボタン
local function onBackBtnRelease() -- ログインボタンを押された場合に板新設画面へ
	composer.gotoScene( "login", "fromBottom", 500 )
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

local boardNameHelp = display.newText( "ボードタイトル：", _W/6, _H/4, native.systemFont, 26 )
boardNameHelp.anchorX = 0 -- 表示文字の基準点のx座標
boardNameHelp.anchorY = 0 -- 表示文字の基準点のy座標
boardNameHelp:setTextColor(0,0,0)

local categoryHelp = display.newText( "カテゴリー：", _W/6, _H/2 - 50, native.systemFont, 26 )
categoryHelp.anchorX = 0 -- 表示文字の基準点のx座標
categoryHelp.anchorY = 0 -- 表示文字の基準点のy座標
categoryHelp:setTextColor(0,0,0)

local boardNameField = native.newTextField( _W/2, _H/4 + 50, _W/3*2, _H/16) -- ボード名を入力させるテキストフィールド
local categoryField = native.newTextField( _W/2, _H/2, _W/3*2, _H/16) -- カテゴリーを入力させるテキストフィールド

local boardName = boardNameField.text -- 入力されたボード名
local category = categoryField.text -- 入力されたカテゴリー

function scene:create( event )
	local sceneGroup = self.view
	local bg = display.newRect( 0, 0, _W, _H ) -- 背景の設定
	bg.anchorX = 0 -- 背景の四角形の基準点のx座標
	bg.anchorY = 0 -- 背景の四角形の基準点のy座標
	bg:setFillColor( 1 )	-- 白

	local title = display.newText( "ボード情報入力画面", 0, 0, native.systemFont, 32 ) -- ページ上部にタイトルを表示
	title:setFillColor( 0 )	-- 黒
	title.x = _W * 0.5
	title.y = 70

	makeBtn = widget.newButton{
		label = "作成",
		labelColor = { default={255}, over={128} },
		defaultFile = "btn.png",
		overFile = "btnover.png",
		width = _W/3*2, height = _H/8,
		emboss = true,
		onRelease = onMakeBtnBtnRelease	-- ボタンを押された際のファンクション呼び出し
	}

	makeBtn.x = _W*0.5
	makeBtn.y = _H /3 *2

	sceneGroup:insert( bg )
	sceneGroup:insert( title )
	sceneGroup:insert( makeBtn )
  sceneGroup:insert( boardNameField )
  sceneGroup:insert( categoryField )
  sceneGroup:insert( boardNameHelp )
  sceneGroup:insert( categoryHelp )
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

        if boardNameField then
            boardNameField:removeSelf()	-- widgets must be manually removed
            boardNameField = nil
        end

        if categoryField then
            categoryField:removeSelf()	-- widgets must be manually removed
            categoryField = nil
        end

	elseif phase == "did" then
			end
end

function scene:destroy( event )
	local sceneGroup = self.view

	--ボタンを削除する
	if makeBtn then
		makeBtn:removeSelf()	-- widgets must be manually removed
		makeBtn = nil
	end

  if boardNameField then
    boardNameField:removeSelf()	-- widgets must be manually removed
    boardNameField = nil
  end

  if categoryField then
    categoryField:removeSelf()	-- widgets must be manually removed
    categoryField = nil
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
