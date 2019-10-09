-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require( "composer" )
local scene = composer.newScene()
local bg, bg2, homeButton

function scene:create(event)

local group= self.view
	-- body
	local widget = require( "widget" ) 
	display.setStatusBar( display.HiddenStatusBar ) 
	local x = display.contentWidth
	local y = display.contentHeight
	
	bg2=display.newRect(x/2, y/2, x,y)
	bg = display.newImage("save.jpg",x/2,y-500)
	bg.alpha = 0.5

	title = display.newText("Preparing a survey",x/2/2+90,50,native.systemFontBold,80)
	title:setFillColor( 0, 0, 0 )

	line = display.newRect(x/2,50, x, 130 )
	line:setFillColor(0,0.35,0  )
	line.alpha=0.3


	


	function getName(event)
	sname = event.target.text
	end

	function getq1(event)
	q1i = event.target.text
	
	end

	function getc1a(event)
	c1ai = event.target.text
	end

	function getc1b(event)
	c1bi = event.target.text
	end

	function getc1c(event)
	c1ci = event.target.text
	end

	function getc1d(event)
	c1di = event.target.text
	end

	
	function createInputbox(event)
		nametxt=display.newText("",250,300,Arial,40)
		nametxt:setFillColor(0, 0, 0.6)
		name=native.newTextField(x-500,300,500,100)
		name.placeholder = "Survey name here" 
		name:addEventListener( "userInput",getName)


		labeltxt=display.newText("Q1:",40,450,Arial,40)
		labeltxt:setFillColor(0, 0, 0.6)
		questionbox=native.newTextField(x/2+20,450,950,90)
		questionbox.placeholder = "Type your survey question here" 
		questionbox:addEventListener( "userInput",getq1)

			c1a=native.newTextField(100,600,500,80) 
			c1a:addEventListener( "userInput",getc1a)
			c1a.placeholder = "A:"
			c1a.anchorX=0

			c1b=native.newTextField(100,750,500,80) 
			c1b:addEventListener( "userInput",getc1b)
			c1b.placeholder = "B:"
			c1b.anchorX=0

			c1c=native.newTextField(100,900,500,80) 
			c1c:addEventListener( "userInput",getc1c)
			c1c.placeholder = "C:"
			c1c.anchorX=0

			c1d=native.newTextField(100,1050,500,80) 
			c1d:addEventListener( "userInput",getc1d)
			c1d.placeholder = "D:"
			c1d.anchorX=0
	end


	inputbox = display.newRoundedRect(970,170, 250,75,20)
	inputbox:setFillColor( 0, 0, 0 )
	inputbox.alpha = 0.3
	inputbox:addEventListener( "tap", createInputbox)
	createtxt= display.newText("Create",950,170,Arial,50)

	


	function save(event)

    --store user inputs into a table
	if sname ~= "" and qli ~= "" and clai ~= "" and c1bi ~= "" and c1ci ~= "" and c1di ~= nil then 
		local dataTable = {}
		for i = 1 , 1 do
		dataTable[i]={}
		dataTable[i].name = sname

			dataTable[i].question = q1i
			
			dataTable[i].choice1 = c1ai
			
			dataTable[i].choice2 = c1bi
			
			dataTable[i].choice3 = c1ci
			
			dataTable[i].choice4 = c1di
		end
		print(dataTable[1].name)


		require "sqlite3"
		local path = system.pathForFile( "data.db", system.DocumentsDirectory)
		local db = sqlite3.open(path)

		--a table for survey question
		local tablesetup = [[CREATE TABLE IF NOT EXISTS survey
							(id INTEGER PRIMARY KEY autoincrement, name, question, choice1, choice2, choice3, choice4);]]
			db:exec(tablesetup)
			for i=1, #dataTable do
			local q = [[INSERT INTO survey VALUES (NULL,']]..dataTable[i].name..[[',']]..dataTable[i].question..[[',']]
						..dataTable[i].choice1..[[',']]..dataTable[i].choice2..[[',']]..dataTable[i].choice3..[[',']]
						..dataTable[i].choice4..[[');]]					
			db:exec(q)	
			end

		--create a table for choice counters for the upon survey question,   id is the same
		local countersetup = [[CREATE TABLE IF NOT EXISTS counter
                    (id INTEGER PRIMARY KEY autoincrement,counterS,counterA, counterB, counterC, counterD);]]
        db:exec(countersetup)
        local c = [[INSERT INTO counter VALUES (NULL, '0' ,'0', '0' , '0' , '0' ); ]]               
         db:exec(c)  

		--get id and show to the user
		for row in db:nrows("SELECT * FROM survey") do
		print("Row " .. row.id)
		id = row.id
		end
		idtxt = display.newText("",x/2,1400,Arial,50)
		idtxt:setFillColor( 0.25, 0 , 0 )
		idtxt.text="Survey is submitted successfully! Your ID: "..id
	else
	native.showAlert( "Something is wrong!", "You must create and enter all the blank fields.", {"OK"} )
	end	
	end


	createbutton = display.newRect(x/1.33, y-50, x/2,100)
	createbutton:setFillColor( 0, 0, 0 )
	createbutton.alpha = 0.5
	createbutton:addEventListener( "tap", save)
	submittxt=display.newText("Submit",x/1.3,y-50,Arial,50)




	function goBack(event)
		composer.gotoScene("home")
	end
	backbutton = display.newRect(x/2/2, y-50, x/2,100)
	backbutton:setFillColor( 0, 0, 0 )
	backbutton.alpha = 0.5
	backtxt=display.newText("Go Back",x/2/2,y-50,Arial,50)
	backbutton:addEventListener("tap",goBack)
	
	

local function onSystemEvent(event)
	if event.type=="applicationExist" then
		if db and db:isopen() then
			db:close( )
		end
	end

end
Runtime:addEventListener( "system", onSystemEvent )





end
























function scene:hide( event )
    if ( event.phase == "will" ) then
        bg:removeSelf()
        bg = nil
        bg2:removeSelf()
        bg2= nil
        backbutton:removeSelf( )

        if nametxt ~= nil then
        name:removeSelf( )
        name:removeEventListener( "userInput", getName)
        name=nil
        questionbox:removeSelf( )      
        questionbox:removeEventListener( "userInput", getq1)
        questionbox=nil
        nametxt:removeSelf( )
        nametxt=nil
        labeltxt:removeSelf( )
        labeltxt=nil
        c1a:removeSelf()       
        c1a:removeEventListener( "userInput", getc1a)
        
        c1b:removeSelf( )       
        c1b:removeEventListener( "userInput", getc1b)
        
        c1c:removeSelf( )       
        c1c:removeEventListener( "userInput", getc1c)
        
        c1d:removeSelf( )        
        c1d:removeEventListener( "userInput", getc1d)
        
        	if idtxt ~= nil then
        	idtxt:removeSelf( )
        	idtxt=nil
    		end
    	end
    	
    	
        line:removeSelf( )
        createtxt:removeSelf( )
        createbutton:removeSelf( )
       	backtxt:removeSelf( )
       	backtxt=nil
       	submittxt:removeSelf( )
       	submittxt=nil

        composer.removeScene( "newScene" )

    end
end



scene:addEventListener( "create", scene )
scene:addEventListener( "hide", scene )

return scene