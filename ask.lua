-- 質問者が掲示板を選び、質問をするための画面へ動くための画面

-- ライブラリ
local composer = require( "composer" )
local widget = require "widget"
local mui = require( "materialui.mui" )

-- 定数
local _W = display.viewableContentWidth
local _H = display.viewableContentHeight

-- オブジェクト
local scene = composer.newScene()

local bg 							-- 背景
local searchBtn 			-- "検索"ボタン

-- 戻るボタンを押された場合はトップ画面へ
local function onBackBtnRelease()
	composer.gotoScene( "top", "fromBottom", 500 )
	return true
end

-- 検索ボタンを押された場合に板検索一覧の表示
local function onSearchBtnRelease()
	composer.setVariable("inputSearchWord", mui.getWidgetProperty("name-text", "value"))
	composer.gotoScene( "searchResult", "fromRight", 500 )
	return true
end

function scene:create( event )
	local sceneGroup = self.view

	-- 背景設定
	bg 					= display.newRect( 0, 0, _W, _H )
	bg.anchorX 	= 0
	bg.anchorY 	= 0
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
      text      = "質問板検索",
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

		-- タイトルText設定
    titleTextOps = {
      y         = 85,
      x         = _W / 2,
      name      = "title-text",
      text      = "質問板の名前で検索",
      align     = "center",
      width     = 400,
      font      = native.systemFontBold,
      fontSize  = mui.getScaleVal(48),
      fillColor = { 0, 0, 0, 1 },
    }
    mui.newText(titleTextOps)

		-- TextField設定
		mui.newTextField({
			name          = "name-text",
		  labelText     = "板の名前:",
	  	text          = "a",
		  font          = native.systemFont,
	  	width         = mui.getScaleVal(400),
		  height        = mui.getScaleVal(46),
		  x             = _W / 2,
	  	y             = _H / 2,
		  activeColor   = { 0.63, 0.81, 0.181, 1 },
		  inactiveColor = { 0.5, 0.5, 0.5, 1 },
	  	callBack      = mui.textfieldCallBack
		})

		-- 検索ボタン
    mui.newRoundedRectButton({
    	name       = "search-btn",
    	text       = "検索",
    	width      = mui.getScaleVal(200),
    	height     = mui.getScaleVal(80),
    	radius     = mui.getScaleVal(10),
    	x          = _W * 0.75,
    	y          = _H / 3 * 2,
    	font       = native.systemFont,
    	fillColor  = { 0.63, 0.81, 0.181, 1 },
    	textColor  = { 1, 1, 1 },
    	touchpoint = true,
    	callBack   = onSearchBtnRelease
    })

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
