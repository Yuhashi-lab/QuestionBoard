-- 閲覧、質問をしたいボードを選ばせる画面

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

local bg					-- 背景

local DecideBtn		-- 質問板遷移用ボタン

local function getBoards()
	local data = http.request("http://questionboardweb.herokuapp.com/api/v1/boards/search/"..composer.getVariable("inputSearchWord"))
	local boards = json.decode( data ).boards
	return boards
end

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

	sceneGroup:insert( bg )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
	elseif phase == "did" then

		local boards = getBoards()

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
      text      = "検索結果"..#boards.."件がヒットしました",
      align     = "center",
      width     = 400,
      font      = native.systemFont,
      fontSize  = mui.getScaleVal(32),
      fillColor = { 0, 0, 0, 1 },
    }
    mui.newText(resultTextOps)

		-- scroll設定
		-- 各Row設定
		local function onRowRender( event )
		   local row 	= event.row
		   local id 	= row.index

		   row.bg 				= display.newRect( 0, 0, display.contentWidth, 59 )
		   row.bg.anchorX = 0
		   row.bg.anchorY = 0
		   row.bg:setFillColor( 1 )
		   row:insert( row.bg )

		   if event.row.params then
		       local name 	= event.row.params.name
		       local detail = event.row.params.detail

		       row.nameText 				= display.newText(name, 12, 0, native.systemFontBold, 14 )
		       row.nameText.anchorX = 0
		       row.nameText.anchorY = 0.5
					 row.nameText.y 			= 20
					 row.nameText.x 			= 42
		       row.nameText:setFillColor( 0 )

		       row.detailText 				= display.newText(detail, 12, 0, native.systemFont, 12 )
		       row.detailText.anchorX = 0
		       row.detailText.anchorY = 0.5
					 row.detailText.y 			= 40
					 row.detailText.x 			= 42
		       row.detailText:setFillColor( 0.5 )

		       row:insert( row.nameText )
		       row:insert( row.detailText )
		   end

		   return true
		end

		--tableView作成
		local tableView = widget.newTableView({
			left 				= 0,
			top 				= 110,
			height 			= _W,
			width 			= _H,
			onRowRender = onRowRender,
			onRowTouch 	= onRowTouch,
			listener 		= scrollListener
		})

		-- Row挿入
		for i = 1, #boards do
			tableView:insertRow({
				isCategory 	= false,
				rowHeight 	= 60,
				rowColor 		= { default={ 1, 1, 1 }, over={ 1, 0.5, 0, 0.2 } },
				lineColor 	= { 0.90, 0.90, 0.90 },
				params = {
					name 		= boards[i].name,
					detail 	= boards[i].detail
				}
			})
		end
		sceneGroup:insert( tableView )


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
