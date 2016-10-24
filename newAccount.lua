-- 新規登録画面

-- ライブラリ
local composer = require( "composer" )
local widget = require "widget"
local http = require("socket.http")
local ltn12 = require'ltn12'

-- 定数
local _W = display.viewableContentWidth
local _H = display.viewableContentHeight

-- 変数
local inputEmail           --入力Email保存用
local inputPSW          --入力パスワード保存用
local inputPSW2         --入力パスワード(確認)保存用

local reaction          -- 送信ボタンを押した後の反応文字列

-- オブジェクト
local scene = composer.newScene()

local bg                --背景
local bar               -- タイトルバー
local barTitle          -- タイトルバーテキスト

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
  inputEmail   = emailField.text
  inputPSW  = PSWField.text
  inputPSW2 = PSW2Field.text

  if inputPSW:len() < 5 then

      reaction.text = "パスワードは6桁以上です"
      reaction.isVisible = true

  else
    if inputPSW == inputPSW2 then
  -- http request
     local reqbody = "email="..inputEmail.."&password="..inputPSW.."&password_confirmation="..inputPSW2
     respbody = {}
     local body, code, headers, status = http.request{
         url = "http://localhost:3000/api/v1/auth",
         method = "POST",
         headers =
         {
             ["Accept"] = "*/*",
             ["Content-Type"] = "application/x-www-form-urlencoded",
             ["content-length"] = string.len(reqbody)
         },
         source = ltn12.source.string(reqbody),
         sink = ltn12.sink.table(respbody)
     }
     print(table.concat(respbody))
     -- get user info
     userInfo["uId"]         = headers["uid"]
     userInfo["accessToken"] = headers["access-token"]
     userInfo["Client"]      = headers["client"]

     if(userInfo["uId"]==nil or userInfo["accessToken"]==nil or userInfo["Client"]==nil) then
         reaction.text = "Failed"
         reaction.isVisible = true
     else
          reaction.text = "ご登録ありがとうございました。"
          reaction.isVisible = true
              -- 戻るボタンが押されたらログイン画面に戻る
              local function gotoMakeboard()
                reaction.isVisible = false
              	composer.gotoScene( "makeBoard", "fromBottom", 500 )
              	return true
              end
              timer.performWithDelay(2000, gotoMakeboard)
    end
    else
      reaction.text = "確認用パスワードが違います"
      reaction.isVisible = true
    end
  end
end

-- 戻るボタンが押されたらログイン画面に戻る
local function onBackBtnRelease()
	composer.gotoScene( "login", "fromLeft", 500 )
	return true
end


function scene:create( event )
	local sceneGroup = self.view

  -- 背景設定
	bg         = display.newRect( 0, 0, _W, _H )
  bg.anchorX = 0
  bg.anchorY = 0
  bg:setFillColor( 1 )

  -- バー設定
  bar   = display.newRect(0, 0, _W, _H/7)
  bar.x = _W/2
  bar.y = -8
  bar:setFillColor(0.22, 0.81, 0.87)

  barTitle    = display.newText("新規アカウント作成", 0, 0, native.systemFont, 24)
  barTitle.x  = _W / 2
  barTitle.y  = 5
  barTitle:setFillColor( 0 )

  -- テキスト設定
  emailHelp         = display.newText( "e-mailAddress:", _W/6, _H/4  , native.systemFont, 26 )
  emailHelp.anchorX = 0
  emailHelp.anchorY = 0
  emailHelp:setTextColor(0,0,0)

  PSWHelp         = display.newText( "Pasword(6桁以上):", _W/6, _H/2 - 50, native.systemFont, 26 )
  PSWHelp.anchorX = 0
  PSWHelp.anchorY = 0
  PSWHelp:setTextColor(0,0,0)

  PSW2Help          = display.newText( "Pasword(確認用):", _W/6, _H/4*3 - 100, native.systemFont, 26 )
  PSW2Help.anchorX  = 0
  PSW2Help.anchorY  = 0
  PSW2Help:setTextColor(0,0,0)


  -- ボタン設定
  registrationBtn = widget.newButton{
    label           = "登録メールを送信する",
    labelColor      = { default={255}, over={128} },
    defaultFile     = "imgs/apps/btn.png",
    overFile        = "imgs/apps/btnover.png",
    width           = _W/3*2,
    height          = _H/8,
    emboss          = true,
    onRelease       = onRegistrationBtnRelease
  }
  registrationBtn.x = _W/2
  registrationBtn.y = _H /6 * 5

  back = widget.newButton{
    defaultFile  = "imgs/apps/back-before.png",
    overFile     = "imgs/apps/back.png",
    width        = 50,
    height       = 50,
    emboss       = true,
    onRelease    = onBackBtnRelease
  }
  back.anchorX   = 0
  back.anchorY   = 0
  back.x         = 0
  back.y         = -20


  sceneGroup:insert( bg )
  sceneGroup:insert( bar )
	sceneGroup:insert( barTitle )
  sceneGroup:insert( back )
  sceneGroup:insert( emailHelp )
  sceneGroup:insert( PSWHelp )
  sceneGroup:insert( PSW2Help )
  sceneGroup:insert( registrationBtn )

  reaction = display.newText("", _W/2,_H /6 *5 + 50, native.systemFont, 12)
  reaction:setTextColor(0,0,0)             -- エラー文
  reaction.isVisible = false

  sceneGroup:insert( reaction )

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then

    -- 入力フィールド設定
    emailField = native.newTextField( _W/2, _H/4 + 50, _W/3*2, _H/16)

    PSWField          = native.newTextField( _W/2, _H/2, _W/3*2, _H/16)
    PSWField.isSecure = true

    PSW2Field           = native.newTextField( _W/2, _H/4*3 - 50, _W/3*2, _H/16)
    PSW2Field.isSecure  = true

    sceneGroup:insert( emailField )
    sceneGroup:insert( PSWField )
    sceneGroup:insert( PSW2Field )

	elseif phase == "did" then

	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

    if emailField then
        emailField:removeSelf()
    end

    if PSWField then
        PSWField:removeSelf()
    end

    if PSW2Field then
        PSW2Field:removeSelf()
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
