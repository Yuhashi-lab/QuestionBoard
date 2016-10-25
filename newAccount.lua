-- 新規登録画面

-- ライブラリ
local composer = require( "composer" )
local widget = require "widget"
local http = require("socket.http")
local ltn12 = require'ltn12'
local mui = require( "materialui.mui" )

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

-- 登録ボタンが押されたらフラッシュを出してログイン画面に戻る
local function onRegistrationBtnRelease()
  inputEmail    = mui.getWidgetProperty("email-text",    "value")
  inputPSW      = mui.getWidgetProperty("pwd-text",      "value")
  inputPSW2     = mui.getWidgetProperty("pwd-conf-text", "value")

  if inputPSW:len() < 5 then
      reaction = "パスワードは6桁以上です"
  else
    if inputPSW == inputPSW2 then
      -- http request
     local reqbody = "email="..inputEmail.."&password="..inputPSW.."&password_confirmation="..inputPSW2
     respbody = {}
     local body, code, headers, status = http.request{
         url = "http://questionboardweb.herokuapp.com/api/v1/auth",
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

      if(userInfo["uId"]==nil or userInfo["accessToken"]==nil or userInfo["Client"]==nil) then
        reaction = "Failed"
      else
        reaction = "ご登録ありがとうございました。"
      end
    else
      reaction = "確認用パスワードが違います"
    end
  end
  mui.newToast({
    name  = "toast",
    text      = reaction,
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

  sceneGroup:insert( bg )

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then

	elseif phase == "did" then

    mui.init()

    -- navbar設定
    mui.newNavbar({
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
      text      = "新規登録",
      align     = "center",
      width     = mui.getScaleVal(200),
      height    = mui.getScaleVal(50),
      font      = native.systemFontBold,
      fontSize  = mui.getScaleVal(40),
      fillColor = { 1, 1, 1, 1 },
    }
    mui.newText(navTextOps)

    mui.newImageRect({
    	image  = "imgs/apps/back.png",
    	name   = "back-btn",
      width  = mui.getScaleVal(100),
    	height = mui.getScaleVal(50),
    })
    local backBtn = mui.getWidgetBaseObject("back-btn")
    backBtn:addEventListener("touch", onBackBtnRelease)
    sceneGroup:insert( backBtn )

    mui.attachToNavBar( "navbar", {
      widgetName = "back-btn",
      widgetType = "Image",
      align      = "left",
    })

    mui.attachToNavBar( "navbar", {
      widgetName = "nav-text",
	    widgetType = "Text",
	    align      = "left",
    })

    -- Textフィールド設定
    mui.newTextField({
    	name          = "email-text",
    	labelText     = "E-mail:",
    	text          = "admin@email.com",
    	font          = native.systemFont,
    	width         = mui.getScaleVal(400),
    	height        = mui.getScaleVal(46),
    	x             = _W/2,
    	y             = _H / 4 + 50,
    	activeColor   = { 0.63, 0.81, 0.181, 1 },
    	inactiveColor = { 0.5, 0.5, 0.5, 1 },
    	callBack      = mui.textfieldCallBack
    })

    mui.newTextField({
      name          = "pwd-text",
      labelText     = "Password:",
      text          = "",
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

    mui.newTextField({
      name          = "pwd-conf-text",
      labelText     = "パスワード(確認):",
      text          = "",
      font          = native.systemFont,
      width         = mui.getScaleVal(400),
      height        = mui.getScaleVal(46),
      x             = _W/2,
      y             =  _H/4*3 - 50,
      activeColor   = { 0.63, 0.81, 0.181, 1 },
      inactiveColor = { 0.5, 0.5, 0.5, 1 },
      callBack      = mui.textfieldCallBack
    })

    -- 新規登録ボタン
    mui.newRoundedRectButton({
    	name       = "regist-btn",
    	text       = "新規登録",
    	width      = mui.getScaleVal(200),
    	height     = mui.getScaleVal(80),
    	radius     = mui.getScaleVal(10),
    	x          = _W  * 0.75,
    	y          = _H / 6 * 5,
    	font       = native.systemFont,
    	fillColor  = { 0.63, 0.81, 0.181, 1 },
    	textColor  = { 1, 1, 1 },
    	touchpoint = true,
    	callBack   = onRegistrationBtnRelease
    })



	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

	elseif phase == "did" then
    mui.destroy()
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
