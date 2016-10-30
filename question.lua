-- 回答者(企業側)が掲示板を確認する画面

-- ライブラリ
local composer = require( "composer" )
local widget = require "widget"
local mui = require( "materialui.mui" )
local http = require("socket.http")
local json = require "json"
local ltn12 = require'ltn12'

-- 定数
local _W = display.viewableContentWidth
local _H = display.viewableContentHeight

-- オブジェクト
local scene = composer.newScene()

local bg 				-- 背景
local registBtn

-- 戻るボタンを押したら質問板に戻る
local function onBackBtnRelease()
	composer.gotoScene( "boardMenuFromAsk", "fromLeft", 500 )
	return true
end

--投稿ボタンを押したらフラッシュを出して質問板に戻る
local function onRegistrationBtnRelease()
  local react   = "質問を送信しました。元のページへ戻ります。"
  inputName     = mui.getWidgetProperty("name-text",       "value")
  inputQuestion = mui.getWidgetProperty("question-textbox", "value")

  if inputName ~= "" and inputQuestion ~= "" then

    local reqbody = "questioner="..inputName.."&content="..inputQuestion.."&board_id="..composer.getVariable("boardId")
    respbody = {}
    local body, code, headers, status = http.request{
        url = "http://questionboardweb.herokuapp.com/api/v1/questions",
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

      local resp=json.decode(respbody[1])
      if(resp["error"] ~= nil) then
          react = "エラーが発生しました"
      end
    else
      react = "一部入力されていません。"
    end

    mui.newToast({
      name      = "toast",
      text      = react,
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
      callBack  = onBackBtnRelease
    })

		registBtn:removeEventListener("tap", onRegistrationBtnRelease)
    timer.performWithDelay(2000, onBackBtnRelease)
	return true
end

function scene:create( event )
	local sceneGroup = self.view

	-- 背景設定
  bg 					= display.newRect( 0, 0, _W, _H )
	bg.anchorX 	= 0
	bg.anchorY 	= 0

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
      text      = "質問を投稿する",
      align     = "center",
      width     = mui.getScaleVal(300),
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

    mui.newTextField({
     name          = "name-text",
     labelText     = "名前",
     text          = "質問者名を入力",
     font          = native.systemFont,
     width         = mui.getScaleVal(400),
     height        = mui.getScaleVal(46),
     x             = _W/2,
     y             = _H/4 + 50,
     activeColor   = { 0.63, 0.81, 0.181, 1 },
     inactiveColor = { 0.5, 0.5, 0.5, 1 },
     callBack      = mui.textfieldCallBack
    })

    mui.newTextBox({
     name          = "question-textbox",
     labelText     = "質問内容：",
     text          = "",
     font          = native.systemFont,
     fontSize      = mui.getScaleVal(46),
     width         = mui.getScaleVal(400),
     height        = mui.getScaleVal(200),
     x             = _W/2,
     y             = _H/3*2 - 30,
     activeColor   = { 0.12, 0.67, 0.27, 1 },
     inactiveColor = { 0.4, 0.4, 0.4, 1 },
     callBack      = mui.textfieldCallBack,
     isEditable    = true,
     scrollView    = scrollView
    })

    -- 投稿ボタン
    mui.newRoundedRectButton({
     name       = "post-btn",
     text       = "投稿",
     width      = mui.getScaleVal(200),
     height     = mui.getScaleVal(80),
     radius     = mui.getScaleVal(10),
     x          = _W * 0.75,
     y          = _H / 3 * 3 - 80,
     font       = native.systemFont,
     fillColor  = { 0.63, 0.81, 0.181, 1 },
     textColor  = { 1, 1, 1 },
     touchpoint = true,
     callBack   = nil
    })
		registBtn = mui.getWidgetBaseObject("post-btn")
		registBtn:addEventListener("tap", onRegistrationBtnRelease)
		sceneGroup:insert( registBtn )


	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		mui.destroy()
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
