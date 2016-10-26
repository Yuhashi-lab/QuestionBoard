-- 閲覧、質問をしたいボードを選ばせる画面

local composer = require( "composer" )
local widget = require "widget"
local mui = require( "materialui.mui" )

-- 定数
local _W = display.viewableContentWidth
local _H = display.viewableContentHeight

-- オブジェクト
local scene = composer.newScene()

local bg					-- 背景

local DecideBtn		-- 質問板遷移用ボタン

-- 質問板が押されたらその板の画面へ
local function onDecideBtnRelease()
	composer.gotoScene( "boardMenuFromAsk", "fromBottom", 500 )
	return true
end

-- 戻るボタンが押されたら検索画面へ
local function onBackBtnRelease()
	composer.gotoScene( "ask", "fromBottom", 500 )
	return true
end

-- ScrollView listener
local function scrollListener( event )

    local phase = event.phase
    if ( phase == "began" ) then print( "Scroll view was touched" )
    elseif ( phase == "moved" ) then print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then print( "Scroll view was released" )
    end

    -- In the event a scroll limit is reached...
    if ( event.limitReached ) then
        if ( event.direction == "up" ) then print( "Reached bottom limit" )
        elseif ( event.direction == "down" ) then print( "Reached top limit" )
        elseif ( event.direction == "left" ) then print( "Reached right limit" )
        elseif ( event.direction == "right" ) then print( "Reached left limit" )
        end
    end

    return true
end

function scene:create( event )
	local sceneGroup = self.view

	-- 背景設定
	bg 					= display.newRect( 0, 0, _W, _H )
	bg.anchorX 	= 0
	bg.anchorY 	= 0
	bg:setFillColor( 1 )

	-- ボタン設定
	DecideBtn = widget.newButton{
		label 			= "○○説明会2016",
		labelColor 	= { default={255}, over={128} },
		defaultFile = "imgs/apps/btn.png",
		overFile 		= "imgs/apps/btnover.png",
		width 			= _W/3*2,
		height 			= _H/6,
		emboss 			= true,
		onRelease 	= onDecideBtnRelease
	}
	DecideBtn.x 	= _W*0.5
	DecideBtn.y 	= _H /3 *2

	sceneGroup:insert( bg )
	sceneGroup:insert( DecideBtn )
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
      text      = "検索結果",
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

    -- 検索結果Text設定
    resultTextOps = {
      y         = 85,
      x         = _W / 2,
      name      = "result-text",
      text      = "検索結果n件がヒットしました",
      align     = "center",
      width     = 400,
      font      = native.systemFont,
      fontSize  = mui.getScaleVal(32),
      fillColor = { 0, 0, 0, 1 },
    }
    mui.newText(resultTextOps)

		local scrollView = widget.newScrollView(
		    {
		        top = 110,
		        left = 0,
		        width = _W,
		        height = _H,
		        scrollWidth = 0,
		        scrollHeight = 1000,
						horizontalScrollDisabled = true,
		        listener = scrollListener
		    }
		)

		-- Create a image and insert it into the scroll view
		background 					= display.newRect( 0, 0, _W, _H )
		background:setFillColor( 0 )
		background.anchorX 	= 0
		background.anchorY 	= 0
		scrollView:insert( background )
		sceneGroup:insert( scrollView )


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
