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

-- 質問入力画面へ進む
local function onAskBtnRelease()
	composer.setVariable("boardId", board.id)
	composer.gotoScene( "question", "fromBottom", 500 )
	return true
end

-- 検索結果画面へ戻る
local function onBackBtnRelease()
	composer.gotoScene( "searchResult", "fromBottom", 500 )
	return true
end

function scene:create( event )
	local sceneGroup = self.view
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
	elseif phase == "did" then
		mui.init()

		-- データ
		boardData 		= http.request("http://questionboardweb.herokuapp.com/api/v1/boards/"..composer.getVariable("boardId"))
		board 				= json.decode(boardData)
		questionsData = http.request("http://questionboardweb.herokuapp.com/api/v1/boards/"..composer.getVariable("boardId").."/questions")
		questions 		= json.decode(questionsData)["questions"]

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
      text      = board.name,
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

		local scrollView = widget.newScrollView({
			top 											= 50,
			left 											= 0,
			width 										= _W,
			height										= _H,
			scrollWidth 							= 0,
			scrollHeight 							= 0,
			horizontalScrollDisabled 	= true
		})
		local bg = display.newImageRect( "imgs/apps/CorkBoard.jpg", _W, _H )
		bg.anchorX = 0
		bg.Y = 0
		scrollView:insert(bg)
		sceneGroup:insert( scrollView )

		postitGroup = display.newGroup()
		for i = 1, #questions do
			local postit 	= display.newImageRect(postitGroup, "imgs/apps/postit"..(math.random(100) % 4)..".png", 200, 200)
			postit.x 			= math.random(110,_W-110)
			postit.y  		= (i -1) * 200 + 150

			postitGroup:insert( postit )
			scrollView:insert( postit )

			print(questions[i].id)
			print(questions[i].content)
			print(questions[i].questioner)
		end

		mui.newRoundedRectButton({
			name 				= "switchSceneButton",
			text 				= "+",
			width 			= mui.getScaleVal(80),
			height 			= mui.getScaleVal(80),
			radius 			= mui.getScaleVal(42),
			x 					= _W - 30,
			y 					= _H,
			font 				= native.systemFontBold,
			fillColor 	= { 0.63, 0.81, 0.181 },
			textColor 	= { 1, 1, 1 },
			touchpoint 	= true,
			callBack 		= onAskBtnRelease
		})

	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		mui.destroy()
		display.remove( postitGroup )
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
