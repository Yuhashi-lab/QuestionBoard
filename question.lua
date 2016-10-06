-- 質問内容を入力する画面


local composer = require( "composer" )
local scene = composer.newScene()

local widget = require "widget"

local _W = display.viewableContentWidth -- 画面の幅の取得
local _H = display.viewableContentHeight -- 画面の高さの取得
local reaction -- 送信ボタンを押した後の反応


local registration -- 登録ボタン
local function onRegistrationBtnRelease() -- 前画面に戻る
  local function closePage()
      reaction.text = nil
  composer.gotoScene( "boardMenuFromAsk", "fromBottom", 500 )
end
reaction = display.newText("質問を送信しました。元のページへ戻ります。",_W/2,_H /6 *5 + 50, native.systemFont, 12)
reaction:setTextColor(0,0,0)
  timer.performWithDelay(2000, closePage)

	return true
end

local back -- 前の画面に戻るボタン
local function onBackBtnRelease() -- 前画面に戻る
	composer.gotoScene( "boardMenuFromAsk", "fromBottom", 500 )
	return true
end
back = widget.newButton{
	defaultFile = "back-before.png",
	overFile = "back.png",
	width = 50, height = 50,
	emboss = true,
	onRelease = onBackBtnRelease	-- ボタンを押された際のファンクション呼び出し
}
	back.anchorX = 0 -- 基準点のx座標
	back.anchorY = 0 -- 基準点のy座標
	back.x = 0
	back.y = 0


  local titleHelp = display.newText( "質問タイトル:", _W/6, _H/4  , native.systemFont, 26 )
  titleHelp.anchorX = 0 -- 表示文字の基準点のx座標
  titleHelp.anchorY = 0 -- 表示文字の基準点のy座標
  titleHelp:setTextColor(0,0,0)

  local questionHelp = display.newText( "質問内容:", _W/6, _H/2 - 50, native.systemFont, 26 )
  questionHelp.anchorX = 0 -- 表示文字の基準点のx座標
  questionHelp.anchorY = 0 -- 表示文字の基準点のy座標
  questionHelp:setTextColor(0,0,0)




  local titleField = native.newTextField( _W/2, _H/4 + 50, _W/3*2, _H/16) -- アドレスを入力させるテキストフィールド
  local questionField = native.newTextBox( _W/2, _H/3*2 - 30, _W/3*2, _H/4) -- パスワードを入力させるテキストフィールド
questionField.size = 12


  local inputtitle = titleField.text -- 入力されたタイトル
  local inputquestion = questionField.text -- 入力された質問


  registration = widget.newButton{
		label = "質問を投稿する",
		labelColor = { default={255}, over={128} },
		defaultFile = "btn.png",
		overFile = "btnover.png",
		width = _W/3*2, height = _H/8,
		emboss = true,
		onRelease = onRegistrationBtnRelease	-- ボタンを押された際のファンクション呼び出し
	}
    registration.x = _W/2
    registration.y = _H /6 *5


  function scene:create( event )
  	local sceneGroup = self.view
  	local bg = display.newRect( 0, 0, _W, _H ) -- 背景の設定
  	bg.anchorX = 0 -- 背景の四角形の基準点のx座標
  	bg.anchorY = 0 -- 背景の四角形の基準点のy座標
  	bg:setFillColor( 1 )	-- 白

    local title = display.newText( "質問入力画面", 0, 0, native.systemFont, 32 ) -- ページ上部にタイトルを表示
  	title:setFillColor( 0 )	-- 黒
  	title.x = _W/2
  	title.y = 70



	sceneGroup:insert( bg )
	sceneGroup:insert( title )
	sceneGroup:insert( back )

  sceneGroup:insert( titleHelp )
  sceneGroup:insert( titleField )
  sceneGroup:insert( questionHelp )
  sceneGroup:insert( questionField )


  sceneGroup:insert( registration )


end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
	elseif phase == "did" then

	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

    if titleField then
        titleField:removeSelf()	-- widgets must be manually removed
        titleField = nil
    end

    if questionField then
        questionField:removeSelf()	-- widgets must be manually removed
        questionField = nil
    end





	elseif phase == "did" then
			end
end

function scene:destroy( event )
	local sceneGroup = self.view

  if boardName then
    boardName:removeSelf()	-- widgets must be manually removed
    boardName = nil
  end

  if registration then
    registration:removeSelf()	-- widgets must be manually removed
    registration = nil
  end



end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
