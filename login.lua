-- ログイン画面

-- ライブラリ
local composer = require( "composer" )
local widget = require "widget"

-- 定数
local _W = display.viewableContentWidth 		-- 画面の幅の取得
local _H = display.viewableContentHeight 		-- 画面の高さの取得

-- 変数
local inputID						--入力されたID取得用
local inputPSW					--入力されたパスワード取得用

-- オブジェクト
local scene = composer.newScene()

local bg								--背景
local title							--タイトルテキスト

local IDHelp						--"ID:"テキスト
local PSWHelp						--"Password:"テキスト

local IDField						--ID入力フィールド
local PSWField					--パスワード入力フィールド

local LoginBtn 					-- "ログイン"ボタン
local newAccountBtn 		-- "新規入会"ボタン
local backBtn 					-- 戻るボタン

-- 戻るボタンを押された際にトップ画面へ
local function onBackBtnRelease()
	composer.gotoScene( "top", "fromBottom", 500 )
	return true
end

-- ログインボタンを押された場合に板新設画面へ
local function onLoginBtnRelease()
	inputID 	= IDField.text
	inputPSW 	= PSWField.text

	composer.gotoScene( "makeBoard", "fromBottom", 500 )
	return true
end

-- 新規入会ボタンを押された場合にアカウント作成画面へ
local function onNewAccountBtnRelease()
	composer.gotoScene( "newAccount", "fromBottom", 500 )
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
	title 	= display.newText( "Login", 0, 0, native.systemFont, 32 )
	title.x = _W / 2
	title.y = 70
	title:setFillColor( 0 )


	--入力フィールド用テキスト
	IDHelp 					= display.newText( "ID:", _W / 6, _H / 4 , native.systemFont, 26 )
	IDHelp.anchorX 	= 0
	IDHelp.anchorY 	= 0
	IDHelp:setTextColor(0,0,0)

	PSWHelp 				= display.newText( "Password:", _W / 6, _H / 2 - 50, native.systemFont, 26 )
	PSWHelp.anchorX = 0
	PSWHelp.anchorY = 0
	PSWHelp:setTextColor(0,0,0)

	--遷移ボタン
	LoginBtn = widget.newButton{
		label 			= "ログイン",
		labelColor 	= { default={255}, over={128} },
		defaultFile = "btn.png",
		overFile 		= "btnover.png",
		width 			= _W / 3 * 2,
		height 			= _H / 8,
		emboss 			= true,
		onRelease 	= onLoginBtnRelease
	}
    LoginBtn.x = _W*0.5
    LoginBtn.y = _H/3*2

  newAccountBtn = widget.newButton{
		label 				= "新規入会",
		labelColor 		= { default={0}, over={128} },
		defaultFile 	= "btn.png",
		overFile			= "btnover.png",
		width 				= _W / 3 * 2,
		height	 			= _H / 16,
		emboss 				= true,
		onRelease 		= onNewAccountBtnRelease
	}
  newAccountBtn.x = _W*0.5
  newAccountBtn.y = _H/3*2+50

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
	sceneGroup:insert( LoginBtn )

  sceneGroup:insert( IDHelp )
  sceneGroup:insert( PSWHelp )
  sceneGroup:insert( newAccountBtn )
	sceneGroup:insert( backBtn )

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then

		--入力フィールド
		IDField 					= native.newTextField( _W/2, _H/4+50, _W/3*2, _H/16)
		PSWField 					= native.newTextField( _W/2, _H/2, _W/3*2, _H/16)
		PSWField.isSecure = true

		sceneGroup:insert( IDField )
	  sceneGroup:insert( PSWField )

	elseif phase == "did" then

	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		if IDField then
				IDField:removeSelf()
		end

		if PSWField then
				PSWField:removeSelf()
		end
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
