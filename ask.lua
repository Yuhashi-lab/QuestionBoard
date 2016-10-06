-- 質問者が掲示板を選び、質問をするための画面へ動くための画面

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require "widget"

local _W = display.viewableContentWidth -- 画面の幅の取得
local _H = display.viewableContentHeight -- 画面の高さの取得

local searchBtn -- "検索"と書かれたボタン
local back -- 前の画面に戻るボタン
local function onBackBtnRelease() -- ログインボタンを押された場合に板新設画面へ
	composer.gotoScene( "top", "fromBottom", 500 )
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


local function onSearchBtnRelease() -- 検索ボタンを押された場合に板検索一覧の表示
	composer.gotoScene( "searchResult", "fromBottom", 500 )
	return true
end


local nameHelp = display.newText( "板の名前を検索", _W/6, _H/4 , native.systemFont, 26 )
nameHelp.anchorX = 0 -- 表示文字の基準点のx座標
nameHelp.anchorY = 0 -- 表示文字の基準点のy座標
nameHelp:setTextColor(0,0,0)

local categoryHelp = display.newText( "カテゴリー名で検索", _W/6, _H/2 - 50, native.systemFont, 26 )
categoryHelp.anchorX = 0 -- 表示文字の基準点のx座標
categoryHelp.anchorY = 0 -- 表示文字の基準点のy座標
categoryHelp:setTextColor(0,0,0)


local nameField = native.newTextField( _W/2, _H/4 + 50, _W/3*2, _H/16) -- IDを入力させるテキストフィールド
local categoryField = native.newTextField( _W/2, _H/2, _W/3*2, _H/16) -- IDを入力させるテキストフィールド

local inputID = nameField.text -- 入力された名前
local inputPSW = categoryField.text -- 入力されたカテゴリー名


function scene:create( event )
	local sceneGroup = self.view
	local bg = display.newRect( 0, 0, _W, _H ) -- 背景の設定
	bg.anchorX = 0 -- 背景の四角形の基準点のx座標
	bg.anchorY = 0 -- 背景の四角形の基準点のy座標
	bg:setFillColor( 1 )	-- 白


	local title = display.newText( "ボード検索", 0, 0, native.systemFont, 32 ) -- ページ上部にタイトルを表示
	title:setFillColor( 0 )	-- 黒
	title.x = _W/2
	title.y = 70

	searchBtn = widget.newButton{
		label = "検索",
		labelColor = { default={255}, over={128} },
		defaultFile = "btn.png",
		overFile = "btnover.png",
		width = _W/3*2, height = _H/8,
		emboss = true,
		onRelease = onSearchBtnRelease	-- ボタンを押された際のファンクション呼び出し
	}
    searchBtn.x = _W*0.5
    searchBtn.y = _H /3 *2




	sceneGroup:insert( bg )
	sceneGroup:insert( title )
	sceneGroup:insert( searchBtn )
  sceneGroup:insert( nameField )
  sceneGroup:insert( categoryField )
  sceneGroup:insert( nameHelp )
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

    if nameField then
        nameField:removeSelf()	-- widgets must be manually removed
        nameField = nil
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
	if searchBtn then
		searchBtn:removeSelf()	-- widgets must be manually removed
		searchBtn = nil
	end

	if back then
		back:removeSelf()	-- widgets must be manually removed
		back = nil
	end

  if nameHelp then
    nameHelp:removeSelf()	-- widgets must be manually removed
    nameHelp = nil
  end

  if categoryHelp then
    categoryHelp:removeSelf()	-- widgets must be manually removed
    categoryHelp = nil
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
