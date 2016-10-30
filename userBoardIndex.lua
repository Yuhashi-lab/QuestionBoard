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


local function getBoards()
	-- http request
	local reqbody = ""
	local respbody = {}
	local body, code, headers, status = http.request{
			url = "http://questionboardweb.herokuapp.com/api/v1/boards",
			method = "GET",
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
	local boards = json.decode(table.concat(respbody)).boards
	return boards
end

-- トップ画面へ戻る
local function onBackBtnRelease()
	composer.gotoScene( "top", "fromLeft", 500 )
	return true
end

-- 板新設画面へ進む
local function onMakeBtnRelease()
--	composer.setVariable("boardId", board.id)
	composer.gotoScene( "makeBoard", "fromRight", 500 )
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
      text      = "板一覧",
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
			callBack 		= onMakeBtnRelease
		})
		-- scroll設定
		-- 各Row設定
		local function onRowRender( event )
		   local row 	= event.row
		   local id 	= row.index

		   row.bg 				= display.newRect( 0, 0, display.contentWidth, 59 )
		   row.bg.anchorX = 0
		   row.bg.anchorY = 0
		   row.bg:setFillColor( 1 )

			 row.btn	 				= display.newImageRect( "imgs/apps/ahead.png", 50, 50)
			 row.btn.anchorX	= 0
			 row.btn.anchorY	= 0
			 row.btn.x				= _W - 50
			 row.btn.y				= 0
			 local function onBtnRelease()
				 composer.setVariable("boardId", boards[id]["id"])
				 composer.gotoScene( "boardMenu", "fromRight", 500 )
			 end
			 row.btn:addEventListener("touch", onBtnRelease)

			 row:insert( row.bg )
			 row:insert( row.btn )

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
					 row.detailText.y 			= 43
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
