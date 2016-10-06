-- ログイン画面

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require "widget"

local _W = display.viewableContentWidth -- 画面の幅の取得
local _H = display.viewableContentHeight -- 画面の高さの取得

local LoginBtn -- "ログイン"と書かれたボタン
local newAccount -- "新規入会"と書かれたボタン
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


local function onLoginBtnRelease() -- ログインボタンを押された場合に板新設画面へ
	composer.gotoScene( "makeBoard", "fromBottom", 500 )
	return true
end

local function onNewAccountRelease() -- ログインボタンを押された場合に板新設画面へ
	composer.gotoScene( "newAccount", "fromBottom", 500 )
	return true
end


local IDHelp = display.newText( "ID:", _W/6, _H/4 , native.systemFont, 26 )
IDHelp.anchorX = 0 -- 表示文字の基準点のx座標
IDHelp.anchorY = 0 -- 表示文字の基準点のy座標
IDHelp:setTextColor(0,0,0)

local PSWHelp = display.newText( "Pasword:", _W/6, _H/2 - 50, native.systemFont, 26 )
PSWHelp.anchorX = 0 -- 表示文字の基準点のx座標
PSWHelp.anchorY = 0 -- 表示文字の基準点のy座標
PSWHelp:setTextColor(0,0,0)


local IDField = native.newTextField( _W/2, _H/4 + 50, _W/3*2, _H/16) -- IDを入力させるテキストフィールド
local PSWField = native.newTextField( _W/2, _H/2, _W/3*2, _H/16) -- IDを入力させるテキストフィールド
PSWField.isSecure = true

local inputID = IDField.text -- 入力されたID
local inputPSW = PSWField.text -- 入力されたパスワード


function scene:create( event )
	local sceneGroup = self.view
	local bg = display.newRect( 0, 0, _W, _H ) -- 背景の設定
	bg.anchorX = 0 -- 背景の四角形の基準点のx座標
	bg.anchorY = 0 -- 背景の四角形の基準点のy座標
	bg:setFillColor( 1 )	-- 白


	local title = display.newText( "Login", 0, 0, native.systemFont, 32 ) -- ページ上部にタイトルを表示
	title:setFillColor( 0 )	-- 黒
	title.x = _W/2
	title.y = 70

	LoginBtn = widget.newButton{
		label = "ログイン",
		labelColor = { default={255}, over={128} },
		defaultFile = "btn.png",
		overFile = "btnover.png",
		width = _W/3*2, height = _H/8,
		emboss = true,
		onRelease = onLoginBtnRelease	-- ボタンを押された際のファンクション呼び出し
	}
    LoginBtn.x = _W*0.5
    LoginBtn.y = _H /3 *2


  newAccount = widget.newButton{
		label = "新規入会",
		labelColor = { default={0}, over={128} },
		defaultFile = "btn.png",
		overFile = "btnover.png",
		width = _W/3*2, height = _H/16,
		emboss = true,
		onRelease = onNewAccountRelease	-- ボタンを押された際のファンクション呼び出し
	}
  newAccount.x = _W*0.5
  newAccount.y = _H /3 *2 + 50

	sceneGroup:insert( bg )
	sceneGroup:insert( title )
	sceneGroup:insert( LoginBtn )
  sceneGroup:insert( IDField )
  sceneGroup:insert( PSWField )
  sceneGroup:insert( IDHelp )
  sceneGroup:insert( PSWHelp )
  sceneGroup:insert( newAccount )
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

    if IDField then
        IDField:removeSelf()	-- widgets must be manually removed
        IDField = nil
    end

    if PSWField then
        PSWField:removeSelf()	-- widgets must be manually removed
        PSWField = nil
    end

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

	if back then
		back:removeSelf()	-- widgets must be manually removed
		back = nil
	end

  if IDHelp then
    IDHelp:removeSelf()	-- widgets must be manually removed
    IDHelp = nil
  end

  if PSWHelp then
    PSWHelp:removeSelf()	-- widgets must be manually removed
    PSWHelp = nil
  end

  if newAccount then
    newAccount:removeSelf()	-- widgets must be manually removed
    newAccount = nil
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
