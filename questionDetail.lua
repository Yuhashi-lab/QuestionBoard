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


-- 検索結果画面へ戻る
local function onBackBtnRelease()
	composer.gotoScene( "boardMenuFromAsk", "fromBottom", 500 )
	return true
end

function scene:create( event )
	local sceneGroup = self.view

	-- 背景設定
  bg 					= display.newRect( 0, 0, _W, _H )
	bg.anchorX 	= 0
	bg.anchorY 	= 0
	bg:setFillColor(0.5)

	-- 質問内容:Text
	local contentHelpTextOptions = {
		text 			= "質問内容",
		anchorX		= 0,
		anchorY		= 0,
		x 				= _W / 4 - 20,
		y 				= _H / 4,
		width 		= 100,
		font 			= native.systemFont,
		fontSize 	= 20,
		align 		= "left"
	}
	contentHelpText = display.newText( contentHelpTextOptions )
	contentHelpText:setFillColor( 1 )

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
	questionerText:setFillColor( 1 )

	sceneGroup:insert( bg )
	sceneGroup:insert( contentHelpText )
	sceneGroup:insert( questionerText )

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
	elseif phase == "did" then
		mui.init()

		local questionData 		= http.request("http://questionboardweb.herokuapp.com/api/v1/questions/"..composer.getVariable("questionId"))
		local question 				= json.decode(questionData)

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

		-- scrollView作成
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
			text 			= question.content,
			anchorX		= 0,
			anchorY		= 0,
		  x 				= _W / 2 - 70,
			y					= topAlignAxis,
		  width 		= _W / 2 + 10,
		  font 			= native.systemFont,
		  fontSize 	= 16,
		  align 		= "left"
		}
		local contentText = display.newText( contentTextOptions )
		contentText.y = contentText.contentHeight / 2							--自分のHeightを使ってScroll内位置調整
		contentText:setFillColor( 0 )

		contentScrollView:insert( contentText )
		sceneGroup:insert( contentScrollView )

		questionerText.text = "質問者名:"..question.questioner	--質問者名再設定

	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		mui.destroy()

		contentScrollView:removeSelf()
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
