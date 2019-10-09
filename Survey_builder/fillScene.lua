-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require( "composer" )
local scene = composer.newScene()
local bg, bg2, homeButton
r1a=0 
r1b=0
r1c=0
r1d=0
counter=0


function scene:create(event)

local group= self.view

    
	
	local widget = require( "widget" ) 
	display.setStatusBar( display.HiddenStatusBar ) 
	local x = display.contentWidth
	local y = display.contentHeight
	
	bg2=display.newRect(x/2, y/2, x,y)

	bg = display.newImage("save.jpg",x/2,y-500)
	bg.alpha = 0.5

	bg3=display.newRoundedRect(x-100,248,200,250,20)
	bg3:setFillColor( 0,0.35,0 )
	bg3.alpha = 0.35

	title = display.newText("Filling a survey",x/2/2+20,50,native.systemFontBold,80)
    title:setFillColor( 0, 0, 0 )

	line = display.newRect(x/2,50, x, 130 )
	line:setFillColor(0,0.35,0  )
	line.alpha=0.3

	require "sqlite3"
	local path = system.pathForFile( "data.db", system.DocumentsDirectory)
	local db = sqlite3.open ( path )
	

    --read question from the database and save into a table
    local data = {}
	for row in db:nrows("SELECT * FROM survey") do
	
		data[#data+1]=
		{
			name = row.name,
			question = row.question,
			choice1 = row.choice1,
			choice2 = row.choice2,
			choice3 = row.choice3,
			choice4 = row.choice4,
		}
	end


   function getId(event)
	rowid = event.target.text
	return rowid
	end

    idbox = native.newTextField( x-100, 200, 150, 100 )
    idbox.inputType="number"
    idbox.placeholder = "ID:" 
    idbox:addEventListener( "userInput",getId )



    local widget = require ("widget")

    function createSurvey(event)


    	i=tonumber(rowid) 
          --turn user inputed "rowid" into a number, I dont know why it was not a number so i have to do this.
          if i == nil then
            native.showAlert( "Something is wrong!", "You must enter the ID.", {"OK"} )
        elseif i == 0 or i > #data then
            native.showAlert( "Something is wrong!", "ID does not exist.", {"OK"} )
        else
    	   q1nametxt = display.newText("",x/2,300,Arial,70)
   			q1nametxt:setFillColor( 0,0.35,0 )
    		q1nametxt.text = (data[i].name)

   			q1txt = display.newText("",x/2,400,Arial,50)
    		q1txt:setFillColor( 0,0.35,0 )
    		q1txt.text = (data[i].question)

    		c1a = display.newText("",200,500,Arial,50)
    		c1a.anchorX=0
    		c1a:setFillColor( 0,0.35,0)
    		c1a.text = "A."..(data[i].choice1)

    		c1aSwitch = widget.newSwitch
   			{        
    		x = 180,
    		y = 500,    
    		style = "checkbox",    
    		initialSwitchState = false,
    		}

    		c1b = display.newText("",200,600,Arial,50)
    		c1b:setFillColor( 0,0.35,0)
    		c1b.text = "B."..(data[i].choice2)
    		c1b.anchorX=0
    		c1bSwitch = widget.newSwitch
    		{        
    		x = 180,
    		y = 600,    
    		style = "checkbox",    
    		initialSwitchState = false,
    		}

    		c1c = display.newText("",200,700,Arial,50)
    		c1c:setFillColor( 0,0.35,0)
    		c1c.text = "C."..(data[i].choice3)
    		c1c.anchorX=0
    		c1cSwitch = widget.newSwitch
    		{        
    		x = 180,
    		y = 700,    
   			 style = "checkbox",    
    		initialSwitchState = false,
   			 }

    		c1d = display.newText("",200,800,Arial,50)
   			c1d:setFillColor( 0,0.35,0)
    		c1d.text = "D."..(data[i].choice4)
    		c1d.anchorX=0
    		c1dSwitch = widget.newSwitch
    		{        
    		x = 180,
    		y = 800,    
    		style = "checkbox",    
    		initialSwitchState = false,
    		}
        end
	end

	
	
	


    searchButton = display.newRect(x-100,300, 150, 75 )
    idtext= display.newText("Search", x-100, 300, Arial, 40)
    idtext:setFillColor( 0,0,0 )
    searchButton:addEventListener( "tap", createSurvey)

    


     function getRecord(event)
        if rowid == nil or c1aSwitch == nil then
        native.showAlert( "Something is wrong!", "You must enter the ID and choose an answer.", {"OK"} )
        else
        --counter is number of submissions, 
        --r1a,r1b... are the counters for each choice. 
        counter = counter + 1
        if c1aSwitch.isOn == true then
            r1a = r1a + 1
        end
        if c1bSwitch.isOn == true then
            r1b = r1b + 1
        end
        if c1cSwitch.isOn == true then
            r1c = r1c + 1
        end
        if c1dSwitch.isOn == true then
            r1d = r1d + 1
        end

        --prevent user to sumbit without choosing an answer,and mess up the report.
        if r1a == 0 and r1b == 0 and r1c ==0 and r1d == 0 then   
        native.showAlert( "Something is wrong!", "You must choose an answer in order to submit.", {"OK"} )
        else 
        --save number of counters into a table
            local counterTable = {}

            counterTable[1]={}

            counterTable[1].id = i

            counterTable[1].counterS = counter
       
            counterTable[1].counterA = r1a
        
            counterTable[1].counterB = r1b
            
            counterTable[1].counterC = r1c
          
            counterTable[1].counterD = r1d
            
            --update counters into the database, counters increment as the number of this function being called.
                for i=1, #counterTable do
                local c = [[UPDATE counter SET counterS=counterS+']]..counterTable[i].counterS..[[', counterA=counterA+']]
                        ..counterTable[i].counterA..[[',counterB=counterB+']]..counterTable[i].counterB..[[',counterC=counterC+']]..counterTable[i].counterC
                        ..[[',counterD=counterD+']]..counterTable[i].counterD..[['WHERE id=']]..counterTable[i].id..[[';]]                 
                db:exec(c)  
                end
    	           print(counterTable[1].id)
                    idtxt = display.newText("",x/2,1400,Arial,50)
                    idtxt:setFillColor( 0.25, 0 , 0 )
                    idtxt.text="This sample is collected."
                    --go back to home scene, so user cant keep clicking the submit button, also reset the counters to 0 when going back.
                    composer.gotoScene("home")
        end
        end
    end




	local function onSystemEvent(event)
	if event.type=="applicationExist" then
		if db and db:isopen() then
			db:close( )
		end
	end

	end
	Runtime:addEventListener( "system", onSystemEvent )

	


	createbutton = display.newRect(x/1.33, y-50, x/2,100)
	createbutton:setFillColor( 0, 0, 0 )
	createbutton.alpha = 0.5
	createbutton:addEventListener( "tap", getRecord)
	submittxt=display.newText("Submit",x/1.3,y-50,Arial,50)

	function goBack(event)
		composer.gotoScene("home")
	end
	backbutton = display.newRect(x/2/2, y-50, x/2,100)
	backbutton:setFillColor( 0, 0, 0 )
	backbutton.alpha = 0.5
	--backbutton:addEventListener( "tap", save)
	backtxt=display.newText("Go Back",x/2/2,y-50,Arial,50)
	backbutton:addEventListener("tap",goBack)

	
	

end




function scene:hide( event )
    if ( event.phase == "will" ) then
        bg:removeSelf()
        bg= nil
        bg2:removeSelf()
        bg2= nil
        bg3:removeSelf( )
        bg3=nil
        line:removeSelf( )
        title:removeSelf( )
        title=nil
       backbutton:removeSelf( )
       backtxt:removeSelf( )
       createbutton:removeSelf( )
       submittxt:removeSelf( )
       searchButton:removeSelf( )
       idbox:removeSelf( )
       idtext:removeSelf( )
       if q1nametxt ~= nil then
       q1nametxt:removeSelf( )
       q1txt:removeSelf( )
       c1a:removeSelf( )
       c1aSwitch:removeSelf( )
       c1b:removeSelf( )
       c1bSwitch:removeSelf( )
       c1c:removeSelf( )
       c1cSwitch:removeSelf( )
       c1d:removeSelf( )
       c1dSwitch:removeSelf( )
        end
        composer.removeScene( "fillScene" )
    end
end


scene:addEventListener( "create", scene )
scene:addEventListener( "hide", scene )

return scene