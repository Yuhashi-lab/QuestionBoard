-- 質問者が掲示板を選び、質問をするための画面へ動くための画面

-- ライブラリ
local composer = require( "composer" )
local widget = require "widget"

-- 定数
local _W = display.viewableContentWidth
local _H = display.viewableContentHeight

-- 変数
local inputName				--入力された名前保存用
local inputCat 				--入力されたカテゴリ保存用

-- オブジェクト
local scene = composer.newScene()

local bg 							-- 背景
local title 					--タイトル
local searchBtn 			-- "検索"ボタン
local backBtn 				-- 戻るボタン

local nameHelp				-- "板の名前を検索"テキスト
local categoryHelp		-- ”カテゴリー名で検索”テキスト

local nameField				-- 質問板を入力させるテキストフィール
local categoryField 	-- 板のカテゴリを入力させるテキストフィールド


-- 戻るボタンを押された場合はトップ画面へ
local function onBackBtnRelease()
	composer.gotoScene( "top", "fromBottom", 500 )
	return true
end

-- 検索ボタンを押された場合に板検索一覧の表示
local function onSearchBtnRelease()
	inputName = nameField.text -- 入力された名前
	inputCat = categoryField.text -- 入力されたカテゴリー名

	composer.gotoScene( "searchResult", "fromBottom", 500 )
	return true
end

function scene:create( event )
	local sceneGroup = self.view

	-- 背景設定
	bg 					= display.newRect( 0, 0, _W, _H )
	bg.anchorX 	= 0
	bg.anchorY 	= 0
	bg:setFillColor( 1 )

	-- タイトル設定
	title 	= display.newText( "ボード検索", 0, 0, native.systemFont, 32 )
	title.x = _W/2
	title.y = 70
	title:setFillColor( 0 )

	-- テキスト設定
	nameHelp 					= display.newText( "板の名前を検索", _W/6, _H/4 , native.systemFont, 26 )
	nameHelp.anchorX 	= 0
	nameHelp.anchorY 	= 0
	nameHelp:setTextColor(0,0,0)

	categoryHelp 					= display.newText( "カテゴリー名で検索", _W/6, _H/2 - 50, native.systemFont, 26 )
	categoryHelp.anchorX 	= 0
	categoryHelp.anchorY 	= 0
	categoryHelp:setTextColor(0,0,0)

	-- 入力フィールド設定
	nameField 		= native.newTextField( _W/2, _H/4 + 50, _W/3*2, _H/16)
	categoryField = native.newTextField( _W/2, _H/2, _W/3*2, _H/16)

	--ボタン設定
	searchBtn = widget.newButton{
		label 			= "検索",
		labelColor 	= { default={255}, over={128} },
		defaultFile = "btn.png",
		overFile 		= "btnover.png",
		width 			= _W/3*2, height = _H/8,
		emboss 			= true,
		onRelease 	= onSearchBtnRelease
	}
  searchBtn.x 	= _W*0.5
  searchBtn.y 	= _H /3 *2

	backBtn = widget.newButton{
		defaultFile 		= "back-before.png",
		overFile 				= "back.png",
		width 					= 50,
		height 					= 50,
		emboss 					= true,
		onRelease 			= onBackBtnRelease
	}
		backBtn.anchorX = 0
		backBtn.anchorY = 0
		backBtn.x 			= 0
		backBtn.y 			= 0

	sceneGroup:insert( bg )
	sceneGroup:insert( title )
	sceneGroup:insert( searchBtn )
  sceneGroup:insert( nameField )
  sceneGroup:insert( categoryField )
  sceneGroup:insert( nameHelp )
  sceneGroup:insert( categoryHelp )
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

	if backBtn then
		backBtn:removeSelf()	-- widgets must be manually removed
		backBtn = nil
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
