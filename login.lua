-- ログイン画面
-- ライブラリ
local composer = require( "composer" )local widget = require "widget"
local json = require "json"
local http = require("socket.http")
local ltn12 = require'ltn12'
local mui = require( "materialui.mui" )

-- 定数local _W = display.viewableContentWidth 		-- 画面の幅の取得
local _H = display.viewableContentHeight 		-- 画面の高さの取得

-- 変数local inputID						--入力されたID取得用
local inputPSW					--入力されたパスワード取得用

-- オブジェクトlocal scene = composer.newScene()

local bg								--背景

-- widget eventlocal function getTokens()

    -- get text    local emailText     = mui.getWidgetProperty("email-text", "value")    local passwordText  = mui.getWidgetProperty("pwd-text", "value")

    -- ログインAPIのリクエストを送る    -- TODOインジケータ    local reqbody = "email="..emailText.."&password="..passwordText
    local respbody = {}
    local body, code, headers, status = http.request{
        url = "http://questionboardweb.herokuapp.com/api/v1/auth/sign_in",
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

end

-- ログインボタンを押された場合に正しいアカウントであれば板新設画面へ
local function onLoginBtnRelease(event)
  getTokens()
  if(userInfo["uId"]==nil or userInfo["accessToken"]==nil or userInfo["Client"]==nil) then
    mui.newToast({
      name  = "toast",
      text      = "ログインに失敗しました",
      radius    = 0,
      width     = _W+100,
      height    = mui.getScaleVal(50),
      font      = native.systemFont,
      fontSize  = mui.getScaleVal(24),
      fillColor = { 0, 0, 0, 1 },
      textColor = { 1, 1, 1, 1 },
      top       = _H - 30,
      easingIn  = 0,
      easingOut = 500,
      callBack  = function() end
    })
  else
    composer.gotoScene("top", "fromRight")
  end
end

-- 新規入会ボタンを押された場合にアカウント作成画面へlocal function onNewAccountBtnRelease()
	composer.gotoScene( "newAccount", "fromRight", 500 )
end


function scene:create( event )	local sceneGroup = self.view

	-- 背景設定
	bg 					= display.newRect( 0, 0, _W, _H )
	bg.anchorX 	= 0
	bg.anchorY 	= 0
	bg:setFillColor( 1 )

	sceneGroup:insert( bg )
end
function scene:show( event )	local sceneGroup = self.view
	local phase = event.phase
	if phase == "will" then

	elseif phase == "did" then    mui.init()    -- navbar設定    mui.newNavbar({
    	name             = "navbar",
    	height           = mui.getScaleVal(100),
    	left             = 0,
    	top              = 0,
    	fillColor        = { 0.63, 0.81, 0.181 },
    	activeTextColor  = { 1, 1, 1, 1 },
    	padding          = mui.getScaleVal(50),
    })

    navTextOps = {
      x         = mui.getScaleVal(0),
    	y         = mui.getScaleVal(0),
      name      = "nav-text",
      text      = "Login",
      align     = "center",
      width     = mui.getScaleVal(130),
      height    = mui.getScaleVal(50),
      font      = native.systemFontBold,
      fontSize  = mui.getScaleVal(40),
      fillColor = { 1, 1, 1, 1 },
    }
    mui.newText(navTextOps)

    mui.attachToNavBar( "navbar", {
      widgetName = "nav-text",
	    widgetType = "Text",
	    align      = "left",
    })

    -- タイトルText設定
    titleTextOps = {
      y         = 85,
      x         = _W / 2,
      name      = "title-text",
      text      = "QuestionBoard",
      align     = "center",
      width     = 400,
      font      = native.systemFontBold,
      fontSize  = mui.getScaleVal(64),
      fillColor = { 0, 0, 0, 1 },
    }
    mui.newText(titleTextOps)

    -- TextField設定
    mui.newTextField({
    	name          = "email-text",
    	labelText     = "E-mail:",
    	text          = "admin@email.com",
    	font          = native.systemFont,
    	width         = mui.getScaleVal(400),
    	height        = mui.getScaleVal(46),
    	x             = _W / 2,
    	y             = _H / 4 + 50,
    	activeColor   = { 0.63, 0.81, 0.181, 1 },
    	inactiveColor = { 0.5, 0.5, 0.5, 1 },
    	callBack      = mui.textfieldCallBack
    })

    mui.newTextField({
      name          = "pwd-text",
      labelText     = "Password:",
      text          = "administrator",
      font          = native.systemFont,
      width         = mui.getScaleVal(400),
      height        = mui.getScaleVal(46),
      x             = _W / 2,
      y             = _H / 2,
      activeColor   = { 0.63, 0.81, 0.181, 1 },
      inactiveColor = { 0.5, 0.5, 0.5, 1 },
      isSecure      = true,
      callBack      = mui.textfieldCallBack
    })

    -- ログインボタン
    mui.newRoundedRectButton({
    	name       = "login-btn",
    	text       = "ログイン",
    	width      = mui.getScaleVal(200),
    	height     = mui.getScaleVal(80),
    	radius     = mui.getScaleVal(10),
    	x          = _W * 0.75,
    	y          = _H / 3 * 2,
    	font       = native.systemFont,
    	fillColor  = { 0.63, 0.81, 0.181, 1 },
    	textColor  = { 1, 1, 1 },
    	touchpoint = true,
    	callBack   = onLoginBtnRelease
    })

    -- 新規登録ボタン
    mui.newRoundedRectButton({
      name       = "regist-btn",
      text       = "新規登録",
      width      = mui.getScaleVal(200),
      height     = mui.getScaleVal(50),
      radius     = mui.getScaleVal(10),
      x          = _W * 0.75,
      y          = _H / 3 * 2 + 50,
      font       = native.systemFont,
      fillColor  = { 0.63, 0.81, 0.181, 1 },
      textColor  = { 1, 1, 1 },
      touchpoint = true,
      callBack   = onNewAccountBtnRelease
    })


	end
end

function scene:hide( event )	local sceneGroup = self.view
	local phase = event.phase
	if event.phase == "will" then    mui.destroy()

	elseif phase == "did" then
	endend

function scene:destroy( event )	local sceneGroup = self.view

end
----------------------------------------------------------------------------------- Listener setup

scene:addEventListener( "create", scene )scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-----------------------------------------------------------------------------------------

return scene