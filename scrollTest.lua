-- ログイン画面
-- ライブラリ
local composer = require( "composer" )
local json = require "json"
local http = require("socket.http")
local ltn12 = require'ltn12'

-- 定数
local _H = display.viewableContentHeight 		-- 画面の高さの取得

-- 変数
local inputPSW					--入力されたパスワード取得用

-- オブジェクト
local bg								--背景
local title							--タイトルテキスト
local emailHelp						--"email:"テキスト
local PSWHelp						--"Password:"テキスト
local flash             --"ログイン失敗"テキスト

local emailField						--email入力フィールド

local LoginBtn 					-- "ログイン"ボタン
local newAccountBtn 		-- "新規入会"ボタン
local scrollView
local backBtn 					-- 戻るボタン

-- widget event

    -- get text

    -- ログインAPIのリクエストを送る
    local respbody = {}
    local body, code, headers, status = http.request{
        url = "http://localhost:3000/api/v1/auth/sign_in",
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

    -- get user info

    userInfo["uId"]         = headers["uid"]
    userInfo["accessToken"] = headers["access-token"]
    userInfo["Client"]      = headers["client"]

local user = json.decode(table.concat(respbody))["data"]
print(user["id"])

end

local function onLoginBtnRelease(event)-- ログインボタンを押された場合に正しいアカウントであれば板新設画面へ

              if(userInfo["uId"]==nil or userInfo["accessToken"]==nil or userInfo["Client"]==nil) then
            flash.text = "Failed"
            flash.isVisible = true
        else
            composer.gotoScene("makeBoard")
        end
end

-- 新規入会ボタンを押された場合にアカウント作成画面へ
	composer.gotoScene( "newAccount", "fromRight", 500 )
end


function scene:create( event )

  scrollView = widget.newScrollView(
      {
          top = 100,
          left = 10,
          width = 300,
          height = 400,
          scrollWidth = _W,
          scrollHeight = _H,

      }
  )
	-- 背景設定
	bg 					= display.newRect( 0, 0, _W, _H )
	bg.anchorX 	= 0
	bg.anchorY 	= 0
	bg:setFillColor( 1 )

	-- タイトル設定
	title.x = _W / 2
	title.y = 70
	title:setFillColor( 0 )

	--入力フィールド用テキスト
	emailHelp.anchorX 	= 0
	emailHelp.anchorY 	= 0
	emailHelp:setTextColor(0,0,0)

	PSWHelp 				= display.newText( "Password:", _W / 6, _H / 2 - 50, native.systemFont, 26 )
	PSWHelp:setTextColor(0,0,0)

	--遷移ボタン
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

  newAccountBtn = widget.newButton{
		labelColor 		= { default={0}, over={128} },
		defaultFile 	= "btn.png",
		overFile			= "btnover.png",
		width 				= _W / 3 * 2,
		height	 			= _H / 16,
		emboss 				= true,
		onRelease 		= onNewAccountBtnRelease
	}




  newAccountBtn.x = _W*0.5

	sceneGroup:insert( bg )
	sceneGroup:insert( LoginBtn )
  sceneGroup:insert( emailHelp )
  sceneGroup:insert( PSWHelp )
  sceneGroup:insert( newAccountBtn )
  sceneGroup:insert( scrollView )

  flash = display.newText("", _W/2,_H /6 *5 + 50, native.systemFont, 12)
  flash.isVisible = false

  sceneGroup:insert( flash )
end

function scene:show( event )
	local phase = event.phase
	if phase == "will" then

		--入力フィールド
		PSWField 					= native.newTextField( _W/2, _H/2, _W/3*2, _H/16)
		PSWField.isSecure = true

		sceneGroup:insert( emailField )

	elseif phase == "did" then
	end

function scene:hide( event )
	local phase = event.phase
	if event.phase == "will" then
				emailField:removeSelf()
		end
	if PSWField then
				PSWField:removeSelf()
		end

	elseif phase == "did" then
	end

function scene:destroy( event )

end


scene:addEventListener( "create", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-----------------------------------------------------------------------------------------

return scene