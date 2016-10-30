-- 回答者(企業側)が掲示板を作成する画面

-- ライブラリ
local composer 	= require( "composer" )
local widget 		= require "widget"
local mui = require( "materialui.mui" )
local json = require "json"
local http = require("socket.http")
local ltn12 = require'ltn12'
-- 定数
local _W = display.viewableContentWidth
local _H = display.viewableContentHeight

-- 変数
local boardName				-- 入力板名保存用
local category 				-- 入力カテゴリ保存用

-- オブジェクト
local scene = composer.newScene()

local bg							--背景

-- 作成ボタンが押された場合に新しい質問板画面へ
local function onMakeBtnRelease()

	inputTitle  = mui.getWidgetProperty("boardName", "value")
  inputDetail = mui.getWidgetProperty("detail"	 , "value")

	-- http request
	local reqbody = "name="..inputTitle.."&detail="..inputDetail
	respbody = {}
	local body, code, headers, status = http.request{
			url = "http://questionboardweb.herokuapp.com/api/v1/boards",
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

	composer.gotoScene( "boardMenu", "fromRight", 500 )

	return true
end

-- 戻るボタンが押されたらトップ画面へ
local function onBackBtnRelease()
	composer.gotoScene( "top", "fromBottom", 500 )
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

		mui.init()

		-- タイトルText設定
    titleTextOps = {
      y         = 85,
      x         = _W / 2,
      name      = "title-text",
      text      = "板新設",
      align     = "center",
      width     = 400,
      font      = native.systemFontBold,
      fontSize  = mui.getScaleVal(64),
      fillColor = { 0, 0, 0, 1 },
    }
    mui.newText(titleTextOps)

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
			text      = "板を設立する",
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

		mui.newTextField({
			name          = "boardName",
			labelText     = "ボードタイトル:",
			text          = "タイトルを入力",
			font          = native.systemFont,
			width         = mui.getScaleVal(400),
			height        = mui.getScaleVal(46),
			x             = _W / 2,
			y             = _H / 5 * 2,
			activeColor   = { 0.63, 0.81, 0.181, 1 },
			inactiveColor = { 0.5, 0.5, 0.5, 1 },
			callBack      = mui.textfieldCallBack
		})

		mui.newTextField({
			name          = "detail",
			labelText     = "詳細:",
			text          = "詳細はこちらに入力してください",
			font          = native.systemFont,
			width         = mui.getScaleVal(400),
			height        = mui.getScaleVal(46),
			x             = _W / 2,
			y             = _H / 5 * 3,
			activeColor   = { 0.63, 0.81, 0.181, 1 },
			inactiveColor = { 0.5, 0.5, 0.5, 1 },
			callBack      = mui.textfieldCallBack
		})

		-- ボタン設定
		mui.newRoundedRectButton({
			name       = "makebtn",
			text       = "板設立",
			width      = mui.getScaleVal(200),
			height     = mui.getScaleVal(80),
			radius     = mui.getScaleVal(10),
			x          = _W * 0.5,
			y          = _H / 4 * 3,
			font       = native.systemFont,
			fillColor  = { 0.63, 0.81, 0.181, 1 },
			textColor  = { 1, 1, 1 },
			touchpoint = true,
			callBack   = onMakeBtnRelease
		})

		-- 入力フィールド設定

	elseif phase == "did" then

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
