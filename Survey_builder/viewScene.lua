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
	
	display.setStatusBar( display.HiddenStatusBar ) 
	local x = display.contentWidth
	local y = display.contentHeight
	
	bg2=display.newRect(x/2, y/2, x,y)

	bg = display.newImage("save.jpg",x/2,y-500)
	bg.alpha = 0.5

	bg3=display.newRoundedRect(x-100,248,200,250,20)
	bg3:setFillColor( 0,0.35,0 )
	bg3.alpha = 0.35

	title = display.newText("View Survey Report",x/2-150,50,native.systemFontBold,80)
	title:setFillColor( 0, 0, 0 )

	line = display.newRect(x/2,50, x, 130 )
	line:setFillColor(0,0.35,0  )
	line.alpha=0.3



	require "sqlite3"
	local path = system.pathForFile( "data.db", system.DocumentsDirectory)
	local db = sqlite3.open ( path )

	--read question from the database and store into the table, so the index numbers match the primary keys 
	local data = {}
	for row in db:nrows("SELECT * FROM survey") do
		print("Row " .. row.id)

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

	--read counters from the database and store into the table, so the index numbers match the primary keys  
	local cTable={}
	for row in db:nrows("SELECT * FROM counter") do
		print("Row " .. row.id)

		cTable[#cTable+1]=
		{
			counterS = row.counterS,
			counterA = row.counterA,
			counterB = row.counterB,
			counterC = row.counterC,
			counterD = row.counterD,
			
		}
	end

	print(cTable[1].counterS )


	--get user id, which is the primary key for counter and survey tables that match the index for cTable and data.
   function getId(event)
	rowid = event.target.text
	return rowid
	end

	
    idbox = native.newTextField( x-100, 200, 150, 100 )
    idbox.inputType="number"
    idbox.placeholder = "ID:" 
    idbox:addEventListener( "userInput",getId )



    
    --display question into the screen
    function createSurvey(event)
    	local i=tonumber(rowid)  --i matches the index of the data table, which is also the id in the survey table database. 

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

    		

    		c1b = display.newText("",200,700,Arial,50)
    		c1b:setFillColor( 0,0.35,0)
    		c1b.text = "B."..(data[i].choice2)
    		c1b.anchorX=0
    		

    		c1c = display.newText("",200,900,Arial,50)
    		c1c:setFillColor( 0,0.35,0)
    		c1c.text = "C."..(data[i].choice3)
    		c1c.anchorX=0
    		

    		c1d = display.newText("",200,1100,Arial,60)
   			c1d:setFillColor( 0,0.35,0)
    		c1d.text = "D."..(data[i].choice4)
    		c1d.anchorX=0

    		if cTable[i].counterS == nil then
    		notaken = display.newText("",100,1400, Arial,57)
    		notaken.anchorX=0
    		notaken.text="Survey was filled by: 0 person"
    		notaken:setFillColor( 0.2,0.2,0.2)
    		elseif cTable[i].counterS >= 1 then
    		taken = display.newText("",100,1400, Arial,57)
    		taken.anchorX=0
    		taken.text="Survey was filled by: "..(cTable[i].counterS).." person/s"
    		taken:setFillColor( 0.2,0.2,0.2)
    		end
    	end
	end

	
	
	


    searchButton = display.newRect(x-100,300, 150, 75 )
    idtext= display.newText("Search", x-100, 300, Arial, 40)
    idtext:setFillColor( 0,0,0 )
    searchButton:addEventListener( "tap", createSurvey)

    
    --a function that calculates choice counters into percents and generates rectangle charts.
	function show(event)

		j=tonumber(rowid)
		
		if  cTable[j].counterA == 0 then
		a1p = display.newText("",300,600,Arial,50)
		a1p:setFillColor( 0.2,0.2,0.2)
		a1p.text= (0).."%"
		elseif cTable[j].counterA >= 1 then
		achart=display.newRect(200,600,700*cTable[j].counterA/cTable[j].counterS, 100 )
		achart.anchorX=0
		achart.alpha=0.5
		achart:setFillColor( math.random(),math.random(),math.random())
		a1p = display.newText("",300,600,Arial,50)
		a1p:setFillColor( 0.2,0.2,0.2)
		--calculate counters into percent then turn result into string with 1 decimal because if 1/3 it will get a lot of deciamls
		local percent = string.format("%.1f",cTable[j].counterA/cTable[j].counterS*100) 
		a1p.text= (percent).."%"
		end

		if cTable[j].counterB == 0 then
		b1p = display.newText("",300,800,Arial,50)
		b1p:setFillColor( 0.2,0.2,0.2)
		b1p.text= (0).."%"
		elseif cTable[j].counterB >= 1 then
		bchart=display.newRect(200,800,700*cTable[j].counterB/cTable[j].counterS, 100 )
		bchart.anchorX=0
		bchart.alpha=0.5
		bchart:setFillColor( math.random(),math.random(),math.random())
		b1p = display.newText("",300,800,Arial,50)
		b1p:setFillColor( 0.2,0.2,0.2)
		local percent = string.format("%.1f",cTable[j].counterB/cTable[j].counterS*100)  
		b1p.text= (percent).."%"
		end

		if cTable[j].counterC == 0 then
		c1p = display.newText("",300,1000,Arial,50)
		c1p:setFillColor( 0.2,0.2,0.2)
		c1p.text= (0).."%"
		elseif cTable[j].counterC >= 1 then
		cchart=display.newRect(200,1000,700*cTable[j].counterC/cTable[j].counterS, 100 )
		cchart.anchorX=0
		cchart.alpha=0.5
		cchart:setFillColor( math.random(),math.random(),math.random())
		c1p = display.newText("",300,1000,Arial,50)
		c1p:setFillColor( 0.2,0.2,0.2)
		local percent = string.format("%.1f",cTable[j].counterC/cTable[j].counterS*100)
		c1p.text= (percent).."%"
		end

		if cTable[j].counterD == 0 then
		d1p = display.newText("",300,1200,Arial,50)
		d1p:setFillColor( 0.2,0.2,0.2)
		d1p.text= (0).."%"
		elseif cTable[j].counterD >= 1 then
		dchart=display.newRect(200,1200,700*cTable[j].counterD/cTable[j].counterS, 100 )
		dchart.anchorX=0
		dchart.alpha=0.5
		dchart:setFillColor( math.random(),math.random(),math.random())
		d1p = display.newText("",300,1200,Arial,50)
		d1p:setFillColor( 0.2,0.2,0.2)
		local percent = string.format("%.1f",cTable[j].counterD/cTable[j].counterS*100)
		d1p.text= (percent).."%"
		end

	end




	function goBack(event)
		composer.gotoScene("home")
	end
	backbutton = display.newRect(0, y-50, x,100)
	backbutton:setFillColor( 0, 0, 0 )
	backbutton.alpha = 0.5
	backtxt=display.newText("Go Back",x/2/2,y-50,Arial,50)
	backbutton:addEventListener("tap",goBack)

	showButton = display.newRect(x/1.33, y-50, x/2,100)
	showButton:setFillColor( 0, 0, 0 )
	showButton.alpha = 0.5
	showButton:addEventListener( "tap",show)
	showtxt=display.newText("Show Percents",x/1.3,y-50,Arial,50)
	

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
        backtxt:removeSelf( )
        showButton:removeSelf( )
        showtxt:removeSelf( )
        bg3:removeSelf( )
        bg3=nil
        line:removeSelf( )
        title:removeSelf( )
        title=nil
       searchButton:removeSelf( )
       idbox:removeSelf( )
       idtext:removeSelf( )

       if q1nametxt ~= nil then
       	q1nametxt:removeSelf( )
       	q1nametxt=nil
       	q1txt:removeSelf( )
       	q1txt=nil
       	c1a:removeSelf( )  
       	c1a=nil    
       	c1b:removeSelf( )
       	c1b=nil       
       	c1c:removeSelf( )
       	c1c=nil
       	c1d:removeSelf( )
       	c1d=nil
        end

        if taken ~= nil then
		taken:removeSelf( )
       	taken=nil
       	elseif notake ~= nil then
       	notaken:removeSelf()
       	notake=nil
       	end

       if a1p ~= nil then
       a1p:removeSelf( )
       a1p=nil
       b1p:removeSelf( )
       b1p=nil
       c1p:removeSelf( )
       c1p=nil
       d1p:removeSelf( )
       d1p=nil      		
   		end

   		if achart ~= nil then
   		achart:removeSelf( )
   		achart=nil
   		end
   		if bchart ~= nil then
   		bchart:removeSelf( )
   		bchart=nil
   		end
   		if cchart ~= nil then
   		cchart:removeSelf( )
   		cchart=nil
   		end
   		if dchart ~= nil then  
   		dchart:removeSelf( )
   		dchart=nil
   		end
        
        composer.removeScene( "viewScene" )
    end
end


scene:addEventListener( "create", scene )
scene:addEventListener( "hide", scene )

return scene