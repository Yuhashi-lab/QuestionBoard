-- 新規登録画面

-- ライブラリ
local composer = require( "composer" )
local widget = require "widget"

-- 定数
local _W = display.viewableContentWidth
local _H = display.viewableContentHeight

-- 変数
local inputID           --入力ID保存用
local inputPSW          --入力パスワード保存用
local inputPSW2         --入力パスワード(確認)保存用

local reaction          -- 送信ボタンを押した後の反応文字列

-- オブジェクト
local scene = composer.newScene()

local bg                --背景
local title             --タイトル

local emailHelp         -- "e-mailAddress:"テキスト
local PSWHelp           -- "Password:"テキスト
local PSW2Help          -- "Password(確認用):"テキスト

local emailField        -- アドレス入力フィールド
local PSWField          -- パスワード入力フィールド
local PSW2Field         -- 確認パスワード入力フィールド

local registrationBtn   -- "登録メールを送信する""ボタン
local back              -- 戻るボタン


-- 登録ボタンが押されたらフラッシュを出してログイン画面に戻る
local function onRegistrationBtnRelease()
  inputID   = emailField.text
  inputPSW  = PSWField.text
  inputPSW2 = PSW2Field.text

  local function closePage()
      reaction.text = nil
      composer.gotoScene( "login", "fromBottom", 500 )
  end
  reaction = display.newText("確認メールを送信しました。元のページへ戻ります。",_W/2,_H /6 *5 + 50, native.systemFont, 12)
  reaction:setTextColor(0,0,0)
  timer.performWithDelay(2000, closePage)--　TODO:funcで入れれない？

	return true
end

-- 戻るボタンが押されたらログイン画面に戻る
local function onBackBtnRelease()
	composer.gotoScene( "login", "fromBottom", 500 )
	return true
end


function scene:create( event )
	local sceneGroup = self.view

  -- 背景設定
	bg         = display.newRect( 0, 0, _W, _H )
  bg.anchorX = 0
  bg.anchorY = 0
  bg:setFillColor( 1 )

  -- タイトル設定
  title   = display.newText( "新規アカウント作成", 0, 0, native.systemFont, 32 ) -- ページ上部にタイトルを表示
  title.x = _W / 2
  title.y = 70
  title:setFillColor( 0 )

  -- テキスト設定
  emailHelp         = display.newText( "e-mailAddress:", _W/6, _H/4  , native.systemFont, 26 )
  emailHelp.anchorX = 0
  emailHelp.anchorY = 0
  emailHelp:setTextColor(0,0,0)

  PSWHelp         = display.newText( "Pasword:", _W/6, _H/2 - 50, native.systemFont, 26 )
  PSWHelp.anchorX = 0
  PSWHelp.anchorY = 0
  PSWHelp:setTextColor(0,0,0)

  PSW2Help          = display.newText( "Pasword(確認用):", _W/6, _H/4*3 - 100, native.systemFont, 26 )
  PSW2Help.anchorX  = 0
  PSW2Help.anchorY  = 0
  PSW2Help:setTextColor(0,0,0)

  -- 入力フィールド設定
  emailField = native.newTextField( _W/2, _H/4 + 50, _W/3*2, _H/16)

  PSWField          = native.newTextField( _W/2, _H/2, _W/3*2, _H/16)
  PSWField.isSecure = true

  PSW2Field           = native.newTextField( _W/2, _H/4*3 - 50, _W/3*2, _H/16)
  PSW2Field.isSecure  = true

  -- ボタン設定
  registrationBtn = widget.newButton{
    label           = "登録メールを送信する",
    labelColor      = { default={255}, over={128} },
    defaultFile     = "btn.png",
    overFile        = "btnover.png",
    width           = _W/3*2,
    height          = _H/8,
    emboss          = true,
    onRelease       = onRegistrationBtnRelease
  }
  registrationBtn.x = _W/2
  registrationBtn.y = _H /6 *5

  back = widget.newButton{
    defaultFile  = "back-before.png",
    overFile     = "back.png",
    width        = 50,
    height       = 50,
    emboss       = true,
    onRelease    = onBackBtnRelease
  }
  back.anchorX   = 0
  back.anchorY   = 0
  back.x         = 0
  back.y         = 0


  sceneGroup:insert( bg )
  sceneGroup:insert( title )
  sceneGroup:insert( back )
  sceneGroup:insert( emailHelp )
  sceneGroup:insert( emailField )
  sceneGroup:insert( PSWHelp )
  sceneGroup:insert( PSWField )
  sceneGroup:insert( PSW2Help )
  sceneGroup:insert( PSW2Field )
  sceneGroup:insert( registrationBtn )

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

    if emailField then
        emailField:removeSelf()	-- widgets must be manually removed
        emailField = nil
    end

    if PSWField then
        PSWField:removeSelf()	-- widgets must be manually removed
        PSWField = nil
    end

    if PSW2Field then
        PSW2Field:removeSelf()	-- widgets must be manually removed
        PSW2Field = nil
    end



	elseif phase == "did" then
			end
end

function scene:destroy( event )
	local sceneGroup = self.view

  if title then
    title:removeSelf()	-- widgets must be manually removed
    title = nil
  end

  if registrationBtn then
    registrationBtn:removeSelf()	-- widgets must be manually removed
    registrationBtn = nil
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
