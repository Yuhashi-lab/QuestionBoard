-- 回答者(企業側)が掲示板を作成する画面

-- ライブラリ
local composer 	= require( "composer" )
local widget 		= require "widget"

-- 定数
local _W = display.viewableContentWidth
local _H = display.viewableContentHeight

-- 変数
local boardName				-- 入力板名保存用
local category 				-- 入力カテゴリ保存用

-- オブジェクト
local scene = composer.newScene()

local bg							--背景
local title 					--タイトル

local boardNameHelp		-- "ボードタイトル:"テキスト
local categoryHelp 		-- "カテゴリー:"テキスト

local boardNameField 	-- ボード名を入力させるテキストフィールド
local categoryField		-- カテゴリーを入力させるテキストフィールド

local makeBtn 				-- "作成"ボタン
local back 						-- 戻るボタン


-- 作成ボタンが押された場合に新しい質問板画面へ
local function onMakeBtnBtnRelease()
	boardName = boardNameField.text
	category = categoryField.text

	composer.gotoScene( "boardMenu", "fromBottom", 500 )
	return true
end

-- 戻るボタンが押されたらログイン画面へ
local function onBackBtnRelease()
	composer.gotoScene( "login", "fromBottom", 500 )
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
	title 	= display.newText( "ボード情報入力画面", 0, 0, native.systemFont, 32 )
	title.x = _W * 0.5
	title.y = 70
	title:setFillColor( 0 )

	-- テキスト設定
	boardNameHelp 				= display.newText( "ボードタイトル：", _W/6, _H/4, native.systemFont, 26 )
	boardNameHelp.anchorX = 0
	boardNameHelp.anchorY = 0
	boardNameHelp:setTextColor(0,0,0)

	categoryHelp 				 	= display.newText( "カテゴリー：", _W/6, _H/2 - 50, native.systemFont, 26 )
	categoryHelp.anchorX 	= 0
	categoryHelp.anchorY 	= 0
	categoryHelp:setTextColor(0,0,0)

	-- 入力フィールド設定
	boardNameField = native.newTextField( _W/2, _H/4 + 50, _W/3*2, _H/16)
	categoryField = native.newTextField( 	_W/2, _H/2, _W/3*2, _H/16)

	-- ボタン設定
	makeBtn = widget.newButton{
		label 			= "作成",
		labelColor 	= { default={255}, over={128} },
		defaultFile = "btn.png",
		overFile 		= "btnover.png",
		width 			= _W/3*2,
		height 			= _H/8,
		emboss 			= true,
		onRelease 	= onMakeBtnBtnRelease
	}
	makeBtn.x 		= _W * 0.5
	makeBtn.y 		= _H / 3 * 2

	back = widget.newButton{
		defaultFile 	= "back-before.png",
		overFile 			= "back.png",
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
