-- 質問内容を入力する画面

-- ライブラリ
local composer = require( "composer" )
local scene = composer.newScene()

local widget = require "widget"

-- 定数
local _W = display.viewableContentWidth
local _H = display.viewableContentHeight

-- 変数
local inputTitle        -- 入力された質問タイトル保存用
local inputQuestion     -- 入力された質問内容保存用

local reaction          -- 送信ボタンを押した後の反応文字列

-- オブジェクト
local bg                -- 背景
local title             --タイトル

local titleHelp         --"質問タイトル:"テキスト
local questionHelp      --"質問内容:"テキスト

local titleField        --質問タイトル入力フィールド
local questionField     --質問内容入力フィールド

local registrationBtn   -- 登録ボタン
local backBtn           -- 前の画面に戻るボタン


--投稿ボタンを押したらフラッシュを出して質問板に戻る
local function onRegistrationBtnRelease()
  inputTitle    = titleField.text
  inputQuestion = questionField.text

  local function closePage()
      reaction.text = nil
      composer.gotoScene( "boardMenuFromAsk", "fromBottom", 500 )
  end
  reaction = display.newText("質問を送信しました。元のページへ戻ります。",_W/2,_H /6 *5 + 50, native.systemFont, 12)
  reaction:setTextColor(0,0,0)
  timer.performWithDelay(2000, closePage)
	return true
end

-- 戻るボタンを押したら質問板に戻る
local function onBackBtnRelease()
	composer.gotoScene( "boardMenuFromAsk", "fromBottom", 500 )
	return true
end

function scene:create( event )
	local sceneGroup = self.view

  -- 背景
  bg          = display.newRect( 0, 0, _W, _H )
  bg.anchorX  = 0
  bg.anchorY  = 0
  bg:setFillColor( 1 )

  -- タイトル
  title   = display.newText( "質問入力画面", 0, 0, native.systemFont, 32 )
  title.x = _W/2
  title.y = 70
  title:setFillColor( 0 )


  -- 文字列設定
  titleHelp         = display.newText( "質問タイトル:", _W/6, _H/4  , native.systemFont, 26 )
  titleHelp.anchorX = 0
  titleHelp.anchorY = 0
  titleHelp:setTextColor(0,0,0)

  questionHelp          = display.newText( "質問内容:", _W/6, _H/2 - 50, native.systemFont, 26 )
  questionHelp.anchorX  = 0
  questionHelp.anchorY  = 0
  questionHelp:setTextColor(0,0,0)

  -- ボタン設定
  registrationBtn = widget.newButton{
  	label           = "質問を投稿する",
    labelColor      = { default={255}, over={128} },
    defaultFile     = "imgs/apps/btn.png",
  	overFile        = "imgs/apps/btnover.png",
  	width           = _W/3*2,
    height          = _H/8,
    emboss          = true,
    onRelease       = onRegistrationBtnRelease
  }
  registrationBtn.x = _W/2
  registrationBtn.y = _H /6 *5

  backBtn = widget.newButton{
  	defaultFile   = "imgs/apps/back-before.png",
  	overFile      = "imgs/apps/back.png",
    width         = 50,
    height        = 50,
    emboss        = true,
    onRelease     = onBackBtnRelease
  }
  backBtn.anchorX = 0
  backBtn.anchorY = 0
  backBtn.x       = 0
  backBtn.y       = 0

	sceneGroup:insert( bg )
	sceneGroup:insert( title )
	sceneGroup:insert( backBtn )
  sceneGroup:insert( titleHelp )
  sceneGroup:insert( questionHelp )
  sceneGroup:insert( registrationBtn )

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then

    --入力フィールド設定
    titleField               = native.newTextField( _W/2, _H/4 + 50, _W/3*2, _H/16)

    questionField            = native.newTextBox( _W/2, _H/3*2 - 30, _W/3*2, _H/4)
    questionField.size       = 12
    questionField.isEditable = true

    sceneGroup:insert( titleField )
    sceneGroup:insert( questionField )

	elseif phase == "did" then

	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

    if titleField then
        titleField:removeSelf()
    end

    if questionField then
        questionField:removeSelf()
    end

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
