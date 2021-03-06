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
local contentHelpText	-- 質問内容:Text
local questionerText	-- 質問者名:Text
local empathyText			-- 共感数:Text
local answerHelpText	-- 回答:Text
local contentText			-- 質問内容
local answerText			-- 回答内容

local contentScrollView	--質問内容表示用Scroll
local answerScrollView	--回答内容表示用Scroll

-- data
local questionData
local question

local empathyBtn

-- 検索結果画面へ戻る
local function onBackBtnRelease()
	composer.gotoScene( "boardMenuFromAsk", "fromLeft", 500 )
	return true
end

--気になるボタン
local function onEmpathyBtnRelease()
	-- http request
	local reqbody = ""
	local respbody = {}
	local body, code, headers, status = http.request{
			url = "http://questionboardweb.herokuapp.com/api/v1/questions/"..composer.getVariable("questionId").."/empathy",
			method = "POST",
			headers =
			{
					["Accept"] = "*/*",
					["Content-Type"] = "application/x-www-form-urlencoded",
					["Uid"] = userInfo["uId"],
					["Access-token"] = userInfo["accessToken"],
					["Client"] = userInfo["Client"],
					["content-length"] = string.len(reqbody)
			},
			source = ltn12.source.string(reqbody),
			sink = ltn12.sink.table(respbody)
	}
	mui.newToast({
		name  		= "toast",
		text      = "送信しました。",
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

	empathyBtn:removeEventListener( "tap", onEmpathyBtnRelease )
	empathyText.text = "気になる:"..question.empathy_count + 1
end

function scene:create( event )
	local sceneGroup = self.view

	-- 背景設定
  bg 					= display.newRect( 0, 0, _W, _H )
	bg.anchorX 	= 0
	bg.anchorY 	= 0
	bg:setFillColor( 1 )

	-- 質問内容:Text
	local contentHelpTextOptions = {
		text 			= "質問内容",
		anchorX		= 0,
		anchorY		= 0,
		x 				= _W / 4 - 20,
		y 				= _H / 4 - 20,
		width 		= 100,
		font 			= native.systemFont,
		fontSize 	= 20,
		align 		= "left"
	}
	contentHelpText = display.newText( contentHelpTextOptions )
	contentHelpText:setFillColor( 0 )

	-- 質問者名:Text
	local questionerTextOptions = {
		text 			= "",
		anchorX		= 0,
		anchorY		= 0,
		x 				= _W / 2,
		y 				= _H / 2,
		width 		= _W - 30,
		font 			= native.systemFont,
		fontSize 	= 20,
		align 		= "left"
	}
	questionerText = display.newText( questionerTextOptions )
	questionerText:setFillColor( 0 )

	-- 共感数:Text
	local empathyTextOptions = {
		text 			= "",
		anchorX		= 0,
		anchorY		= 0,
		x 				= _W / 2,
		y 				= _H / 2 + 60,
		width 		= _W - 30,
		font 			= native.systemFont,
		fontSize 	= 20,
		align 		= "left"
	}
	empathyText = display.newText( empathyTextOptions )
	empathyText:setFillColor( 0 )

	-- 回答:Text
	local answerTextHelpOptions = {
		text 			= "回答",
		anchorX		= 0,
		anchorY		= 0,
		x 				= _W / 2,
		y 				= _H / 2 + 120,
		width 		= _W - 30,
		font 			= native.systemFont,
		fontSize 	= 20,
		align 		= "left"
	}
	answerHelpText = display.newText( answerTextHelpOptions )
	answerHelpText:setFillColor( 0 )

	-- 質問内容表示用ScrollView作成
	contentScrollView = widget.newScrollView({
		top 											= 70,
		left 											= _W / 2 - 30,
		width 										= _W / 2 + 20,
		height										= _H / 4,
		scrollWidth 							= 0,
		scrollHeight 							= 0,
		hideBackground						= false,
		horizontalScrollDisabled 	= true
	})

	-- contentScrollViewの中身作成
	local contentTextOptions = {
		text 			= "",
		anchorX		= 0,
		anchorY		= 0,
		x 				= _W / 2 - 70,
		y					= topAlignAxis,
		width 		= _W / 2 + 10,
		font 			= native.systemFont,
		fontSize 	= 16,
		align 		= "left"
	}
	contentText = display.newText( contentTextOptions )
	contentText:setFillColor( 0 )
	contentScrollView:insert( contentText )

	-- 回答内容表示用ScrollView作成
	answerScrollView = widget.newScrollView({
		top 											= _H / 2 + 100,
		left 											= _W / 2 - 30,
		width 										= _W / 2 + 20,
		height										= _H / 4,
		scrollWidth 							= 0,
		scrollHeight 							= 0,
		hideBackground						= false,
		horizontalScrollDisabled 	= true
	})

	-- contentScrollViewの中身作成
	local answerTextOptions = {
		text 			= "",
		anchorX		= 0,
		anchorY		= 0,
		x 				= _W / 2 - 70,
		y					= topAlignAxis,
		width 		= _W / 2 + 10,
		font 			= native.systemFont,
		fontSize 	= 16,
		align 		= "left"
	}
	answerText = display.newText( answerTextOptions )
	answerText:setFillColor( 0 )
	answerScrollView:insert( answerText )

	sceneGroup:insert( bg )
	sceneGroup:insert( contentHelpText )
	sceneGroup:insert( questionerText )
	sceneGroup:insert( empathyText)
	sceneGroup:insert( answerHelpText )
	sceneGroup:insert( contentScrollView )
	sceneGroup:insert( answerScrollView)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
	elseif phase == "did" then
		mui.init()

		questionData 		= http.request("http://questionboardweb.herokuapp.com/api/v1/questions/"..composer.getVariable("questionId"))
		question 				= json.decode(questionData)


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
      text      = "質問詳細",
      align     = "left",
      width     = _W,
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

		-- 気になるボタン
    mui.newRoundedRectButton({
    	name       = "empathy-btn",
    	text       = "気になる！",
    	width      = mui.getScaleVal(300),
    	height     = mui.getScaleVal(80),
    	radius     = mui.getScaleVal(10),
			x 				= _W * 0.75,
			y 				= _H / 2 + 60,
    	font       = native.systemFont,
    	fillColor  = { 0.63, 0.81, 0.181, 1 },
    	textColor  = { 1, 1, 1 },
    	touchpoint = true,
    	callBack   = nil
    })
		empathyBtn = mui.getWidgetBaseObject("empathy-btn")
    empathyBtn:addEventListener("tap", onEmpathyBtnRelease)
    sceneGroup:insert( empathyBtn )

		questionerText.text = "質問者名:"..question.questioner	--質問者名再設定
		empathyText.text 		= "気になる:"..question.empathy_count --共感数再設定
		contentText.text		= question.content								 --質問内容再設定
		contentText.y				= contentText.contentHeight / 2
		answerText.text			= "回答がまだありません"
		answerText.y 				= answerText.contentHeight / 2		 --自分のHeightを使ってScroll内位置調整

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
