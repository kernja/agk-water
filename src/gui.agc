
function createGameplayGUI()
    tString as string
    rem create background box
    createSprite(400, 8)
    SetSpritePosition(400, 0, 0)

    rem create playfield sprite
    createSprite(499, 10)
    SetSpritePosition(499,160, 0)
    rem create slider stuff
    rem create sprite for slider map
    deletesprite(402)
    createsprite(402, 10)
    setspritescale(402,0.15,0.15)
    Setspriteposition(402,90,220)

    rem create sprite for slider overlay
    createsprite(403, 13)
    setspriteposition(403,90,220)

    rem create sprite for screen overlap - click to start
    createsprite(404, 15)
    setspriteposition(404,0,0)
    setspritedepth(404, 8)
    setspritevisible(404, 0)

    rem create sprite for pause screen
    createsprite(405, 16)
    setspriteposition(405, 0,0)
    setspritedepth(405, 8)
    setspritevisible(405, 0)

    rem create sprite for fail screen
    createsprite(406, 17)
    setspriteposition(406, 0,0)
    setspritedepth(406, 8)
    setspritevisible(406, 0)

    rem create sprite for clear screen
    createsprite(407, 18)
    setspriteposition(407, 0,0)
    setspritedepth(407, 8)
    setspritevisible(407, 0)

    rem create sprite for clear perfect screen
    createsprite(408, 19)
    setspriteposition(408, 0,0)
    setspritedepth(408, 8)
    setspritevisible(408, 0)
    rem create text
    tString = "LEVEL 100"
    createText(400, tString)
    SetTextFontImage(400, 7)
    SetTextPosition(400, 16, 8)
    SetTextSize(400,29)
    SetTextSpacing(400,-6)

    createText(401, "Goal   1000d")
    SetTextFontImage(401, 7)
    SetTextPosition(401, 16, 29)
    SetTextSize(401,24)
    SetTextSpacing(401,-6)

    createText(402, "At     1000d")
    SetTextFontImage(402, 7)
    SetTextPosition(402, 16, 46)
    SetTextSize(402,24)
    SetTextSpacing(402,-6)

    createText(403, "Made   1000d")
    SetTextFontImage(403, 7)
    SetTextPosition(403, 16, 63)
    SetTextSize(403,24)
    SetTextSpacing(403,-6)

    createText(404, "Action Stage")
    SetTextFontImage(404, 7)
    SetTextPosition(404, 16, 97)
    SetTextSize(404,24)
    SetTextSpacing(404,-6)

    createText(405, "   0 seconds")
    SetTextFontImage(405, 7)
    SetTextPosition(405, 16, 114)
    SetTextSize(405,24)
    SetTextSpacing(405,-6)

    createText(406, "Flood Stage")
    SetTextFontImage(406, 7)
    SetTextPosition(406, 16, 131)
    SetTextSize(406,24)
    SetTextSpacing(406,-6)

    createText(407, "   0 seconds")
    SetTextFontImage(407, 7)
    SetTextPosition(407, 16, 148)
    SetTextSize(407,24)
    SetTextSpacing(407,-6)

    createText(408, "Bombs  0/3")
    SetTextFontImage(408, 7)
    SetTextPosition(408, 16, 182)
    SetTextSize(408,24)
    SetTextSpacing(408,-6)

    createText(409, "Map ")
    SetTextFontImage(409, 7)
    SetTextPosition(409, 16, 216)
    SetTextSize(409,24)
    SetTextSpacing(409,-6)

    createText(410, "PAUSE GAME")
    SetTextFontImage(410, 7)
    SetTextPosition(410, 16, 290)
    SetTextSize(410,24)
    SetTextSpacing(410,-6)

    rem score screen text
    rem droplets
    createText(411, "")
    SetTextFontImage(411, 7)
    SetTextPosition(411, 190, 98)
    SetTextSize(411,26)
    SetTextSpacing(411,-6)
    SetTextDepth(411, 7)
    SetTextVisible(411, 0)
    rem time
    createText(412, "")
    SetTextFontImage(412, 7)
    SetTextPosition(412, 190, 115)
    SetTextSize(412,26)
    SetTextSpacing(412,-6)
    SetTextDepth(412, 7)
    SetTextVisible(412, 0)
    rem bomb
    createText(413, "")
    SetTextFontImage(413, 7)
    SetTextPosition(413, 190, 132)
    SetTextSize(413,26)
    SetTextSpacing(413,-6)
    SetTextDepth(413, 7)
    SetTextVisible(413, 0)
    rem perfect
    createText(414, "")
    SetTextFontImage(414, 7)
    SetTextPosition(414, 190, 149)
    SetTextSize(414,26)
    SetTextSpacing(414,-6)
    SetTextDepth(414, 7)
    SetTextVisible(414, 0)

    rem total score
    createText(415, "")
    SetTextFontImage(415, 7)
    SetTextPosition(415, 190, 174)
    SetTextSize(415,26)
    SetTextSpacing(415,-6)
    SetTextDepth(415, 7)
    SetTextVisible(415, 0)
    rem rank
    createText(416, "")
    SetTextFontImage(416, 7)
    SetTextPosition(416, 190, 193)
    SetTextSize(416,26)
    SetTextSpacing(416,-6)
    SetTextDepth(416, 7)
    SetTextVisible(416, 0)

    rem new high score
    createText(417, "NEW HIGH SCORE!")
    SetTextFontImage(417, 7)
    SetTextPosition(417, 231, 225)
    SetTextSize(417,26)
    SetTextSpacing(417,-6)
    SetTextDepth(417, 7)
    SetTextVisible(417, 0)

    rem replay level
    createText(418, "REPLAY LEVEL")
    SetTextFontImage(418, 7)
    SetTextPosition(418, 174, 257)
    SetTextSize(418,26)
    SetTextSpacing(418,-6)
    SetTextDepth(418, 7)
    SetTextVisible(418, 0)

    rem level select
    createText(419, "LEVEL SELECT")
    SetTextFontImage(419, 7)
    SetTextPosition(419, 330, 257)
    SetTextSize(419,26)
    SetTextSpacing(419,-6)
    SetTextDepth(419, 7)
    SetTextVisible(419, 0)

    rem create text for pause/failure menus
    rem resume game
    createText(420, "RESUME GAME")
    SetTextFontImage(420, 7)
    SetTextPosition(420, 255, 106)
    SetTextSize(420,26)
    SetTextSpacing(420,-6)
    SetTextDepth(420, 7)
    SetTextVisible(420, 0)

    rem resume game
    createText(421, "RESTART LEVEL")
    SetTextFontImage(421, 7)
    SetTextPosition(421, 244, 162)
    SetTextSize(421,26)
    SetTextSpacing(421,-6)
    SetTextDepth(421, 7)
    SetTextVisible(421, 0)

    rem resume game
    createText(422, "LEVEL SELECT")
    SetTextFontImage(422, 7)
    SetTextPosition(422, 250, 216)
    SetTextSize(422,26)
    SetTextSpacing(422,-6)
    SetTextDepth(422, 7)
    SetTextVisible(422, 0)

    rem resume game
    createText(423, "START FLOODING")
    SetTextFontImage(423, 7)
    SetTextPosition(423, 240, 290)
    SetTextSize(423,26)
    SetTextSpacing(423,-6)
    SetTextDepth(423, 7)
    SetTextVisible(423, 0)

    rem hide this all now since we only want to create it at startup
    HideGameplayGUI()
endfunction

function HideGameplayGUI()
    i as integer
    rem hide background bg
    SetSpriteVisible(400, 0)

    rem hide all other sprites
    for i = 402 to 408
        SetSpriteVisible(i, 0)
    next i

    rem hide all possible text
    for i = 400 to 423
        SetTextVisible(i, 0)
    next i

    rem reset main menu text to white
    `SetTextFontImage(410, 7)
    SetTextColor(410,255,255,255,255)

    rem hide playfield
        SetSpriteVisible(499, 0)
endfunction

function ShowDefaultGameplayGUI()
    i as integer
    rem show background bg
    SetSpriteVisible(400, 1)

    rem show all other sprites
    for i = 402 to 403
        SetSpriteVisible(i, 1)
    next i

    rem show playfield
    SetSpriteVisible(499, 1)
    rem show text
    for i = 400 to 410
        SetTextVisible(i, 1)
    next i


endfunction

function UpdateGameplayGUILevel(pLevel as integer)
    myString as string

    `SetTextString(400, "LEVEL")
    if pLevel <= 9
        myString = "LEVEL   "
        myString = myString + str(trunc(pLevel))
        SetTextString(400, myString)
    elseif pLevel >= 10 and pLevel <= 99
        SetTextString(400, "LEVEL  " + str(trunc(pLevel)))
    else
        SetTextString(400, "LEVEL " + str(trunc(pLevel)))
    endif


endfunction

function UpdateGameplayGUI(pPointerX as integer, pPointerY as integer, pCheckInput as integer)
    rem 400 is stage number
    rem 401-403 are droplet strings
    rem 405 is user time
    rem 407 is system time
    rem 408 is bomb text
    tString as string

    rem update stage number
    UpdateGameplayGUILevel(levelSelected + 1)
    rem droplets
    tString = ReturnGUIDropletString(map.mapRequiredDroplets)
    SetTextString(401, "Goal " + tString)

    tString = ReturnGUIDropletString(map.mapMadeDroplets)
    SetTextString(402, "Made " + tString)

    tString = ReturnGUIDropletString(map.mapGoalDroplets)
    SetTextString(403, "At   " + tString)

    rem player time
    tString = ReturnGUITimeString(map.mapCurrentPrepTime)
    SetTextString(405, tString)

    rem system time
    tString = ReturnGUITimeString(map.mapCurrentSystemTime)
    SetTextString(407, tString)

    rem bomb
    if (map.mapBombs - map.mapDroppedBombs) > 9
        tString = "Bombs  " + str(map.mapBombs - map.mapDroppedBombs) + "/" + str(map.mapBombs)
    else
        tString = "Bombs   " + str(map.mapBombs - map.mapDroppedBombs) + "/" + str(map.mapBombs)
    endif

    SetTextString(408, tString)

    rem pause menu
    if pCheckInput = 1
        CheckButtonPointerHover(410, pPointerX, pPointerY, 10, 10)
    endif

    rem scroll image
    setspriteimage(402, ImageMap)
    setspritesize(402,-1,-1)
    setspritescale(402,.15,.15)
endfunction

rem create a function so we don't have to try shooting ourselves
rem manually updating the positions of droplets for each line
function ReturnGUIDropletString(pDroplet as integer)
    myReturn as string
    myReturn = "  "

    if pDroplet <= 9
        myReturn = myReturn + "   " + str(pDroplet)
    elseif pDroplet >= 10 and pDroplet <= 99
        myReturn = myReturn + "  " + str(pDroplet)
    elseif pDroplet >= 100 and pDroplet <= 999
        myReturn = myReturn + " " + str(pDroplet)
    else
        myReturn = myReturn + str(pDroplet)
    endif

    myReturn = myReturn + "d"
endfunction myReturn

rem create a function so we don't have to try shooting ourselves
rem manually updating the time for each line
function ReturnGUITimeString(pTime as float)
    tTime as integer
    tTime = pTime
    `tTime = trunc(pTime)
    myReturn as string
    myReturn = " "

    if tTime <= 9
        myReturn = myReturn + "  " + str(tTime) + " seconds"
    elseif tTime >= 10 and tTime <= 99
        myReturn = myReturn + " " + str(tTime) + " seconds"
    else
        myReturn = myReturn + str(tTime) + " seconds"
    endif

endfunction myReturn

function FormatScoreString(pString as string)
    myReturn as string
    i as integer
    tCount as integer
    tLength as integer

    myReturn = "     "
    tLength = len(pString)

    tCount = 5 - tLength

    for i = 1 to tCount
        myReturn = myReturn + " "
    next

    myReturn = myReturn + pString
endfunction myReturn

function CheckButtonPointerHover(pID as integer, pPointerX as integer, pPointerY as integer, pOffsetX as integer, pOffsetY as integer)
    tX as integer
    tY as integer
    tWidth as integer
    tHeight as integer
    myReturn as integer

    REM comment out these lines to get the app working again
    tX = GetTextX(pID) - pOffsetX
    tY = GetTextY(pID) - pOffsetY
    tWidth = tX + GetTextTotalWidth(pID) + (pOffsetX * 2)
    tHeight = tY + GetTextTotalHeight(pID) + (pOffsetY * 2)

        if tX <= pPointerX and pPointerX <= tWidth and tY <= pPointerY and pPointerY <= tHeight
            if (GetMultiTouchExists() = 1 and GetPointerState() = 1) or GetMultiTouchExists() = 0
                  SetTextColor(pID,255,255,0,255)
            else
                SetTextColor(pID,255,255,255,255)
            endif

            myReturn = 1
        else
                    SetTextColor(pID,255,255,255,255)
        endif
    REM comment out til here

endfunction myReturn
