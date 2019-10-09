-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require( "composer" )
local scene = composer.newScene()
local newButton,bg

function scene:create(event)
	local group=self.view
	-- body
local x = display.contentWidth
local y = display.contentHeight


	bg = display.newImage( "trees.jpg")
	bg.x=x/2
	bg.y=y/2

local text1= display.newText("Survey",x/2-130,y-y+200,native.systemFontBold,80)
text1:setFillColor(0,0.55,0)
local text2= display.newText("Builder",x/2+140,y-y+200,native.systemFontBold,80)
text2:setFillColor(0.1,0.1,0.1)

local foot=display.newText("Created by Xin Jie Li",x-200,y-100,Arial,40)

newButton=display.newRoundedRect(x/2,y/2-300, 500, 100,25)
newButton.alpha = 0.3
local new=display.newText("New Survey", x/2,y/2-300,Arial,70)

fillButton=display.newRoundedRect(x/2,y/2-100, 500, 100,25)
fillButton.alpha = 0.3
local Fill=display.newText("Fill Survey", x/2,y/2-100,Arial,70)

viewButton=display.newRoundedRect(x/2,y/2+100, 500, 100,25)
	viewButton.alpha = 0.3
local view=display.newText( "View Report", x/2,y/2+100,Arial,70)



	function goCreate(event)
		composer.gotoScene("newScene")
	end
	newButton:addEventListener("tap",goCreate)
	
	function fillsurvey(event)
		composer.gotoScene( "fillScene")
	end
	fillButton:addEventListener( "tap",fillsurvey)

	function viewsurvey(event)
		composer.gotoScene( "viewScene")
	end
	viewButton:addEventListener( "tap",viewsurvey)

end

function scene:hide( event )
    if ( event.phase == "will" ) then
        bg:removeSelf()
        bg = nil
        fillButton:removeEventListener( "tap", fillsurvey )
        fillButton:removeSelf()
        fillButton = nil
        
       	viewButton:removeEventListener( "tap", viewsurvey )
        viewButton:removeSelf()
        viewButton = nil
        
        newButton:removeEventListener( "tap", goCreate )
        newButton:removeSelf()
        newButton = nil
        composer.removeScene( "home" )
    end
end


scene:addEventListener( "create", scene )
scene:addEventListener( "hide", scene )

return scene