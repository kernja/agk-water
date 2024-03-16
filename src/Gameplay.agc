rem holds data for our sources of water
rem where water pours from
type TYPE_WATER_SOURCE
    X as integer
    Y as integer

    sourceX as integer
    sourceY as integer

    spriteID as integer
    spriteX as integer
    spriteY as integer
endType
global dim mapWaterSource[1] as TYPE_WATER_SOURCE

rem holds type where water goes to
rem direction 0=down, 1=left, 2=right
type TYPE_WATER_GOAL
    X as integer
    Y as integer

    spriteID as integer
    spriteX as integer
    spriteY as integer

    direction as integer
endType
global dim mapWaterGoal[1] as TYPE_WATER_GOAL

rem bomb
rem where the scenery is destroyed
type TYPE_BOMB
    X as integer
    Y as integer

    spriteID as integer
    spriteX as integer
    spriteY as integer
endtype
global dim mapBomb[1] as TYPE_BOMB

rem map
rem holds all of our map information
type TYPE_MAP
    mapPic as string
    mapWidth as integer
    mapHeight as integer

    mapPrepTime as float
    mapCurrentPrepTime as float

    mapSystemTime as float
    mapCurrentSystemTime as float

    mapCurrentPercent as float

    mapDroplets as integer
    mapMadeDroplets as integer
    mapLostDroplets as integer
    mapGoalDroplets as integer
    mapRequiredDroplets as integer

    mapDropletsNotMovedStep as integer
    mapAltFinished as integer

    mapBombs as integer
    mapDroppedBombs as integer

    arrayWaterGoalCount as integer
    arrayWaterSourceCount as integer
    arrayBombCount as integer

    newMinX as integer
    newMaxX as integer
    newMinY as integer
    newMaxY as integer

    offsetX as integer
    offsetY as integer
    maxOffsetX as integer
    maxOffsetY as integer

    mapState as integer
    mapPauseClick as integer

    levelDropletBonus as integer
    levelTimeBonus as integer
    levelBombBonus as integer
    levelPerfectBonus as integer
    levelScore as integer
    levelRank as string
    levelTimeLastDroplet as float
    multiTouchX as float
    multiTouchY as float
endtype
global map as TYPE_MAP
rem hold pixel data
global dim mapPixelData[1,1] as integer

function ResetMap()
    i as integer

    map.mapPic = ""
    map.mapWidth = -1
    map.mapHeight = -1
    map.mapPrepTime = -1
    map.mapCurrentPrepTime = -1
    map.mapSystemTime = -1
    map.mapCurrentSystemTime = -1
    map.mapCurrentPercent = -1
    map.mapDroplets = 0
    map.mapBombs = 0
    map.mapDroppedBombs = 0
    map.mapMadeDroplets = 0
    map.mapLostDroplets = 0
    map.mapGoalDroplets = 0
    map.mapRequiredDroplets = 0
    map.arrayWaterGoalCount = -1
    map.arrayWaterSourceCount = -1
    map.arrayBombCount = -1
    map.mapState = 0
    map.mapAltFinished = 0
    map.levelDropletBonus = 0
    map.levelTimeBonus = 0
    map.levelBombBonus = 0
    map.levelPerfectBonus = 0
    map.levelScore = 0
    map.levelRank = "E"
    map.levelTimeLastDroplet = 0
    map.mapDropletsNotMovedStep = 0

    dim mapWaterSource[1] as TYPE_WATER_SOURCE
    dim mapWaterGoal[1] as TYPE_WATER_GOAL
    dim mapBomb[1] as TYPE_BOMB	
    dim mapPixelData[1,1]

    map.newMinX = 0
    map.newMaxX = 0
    map.newMinY = 0
    map.newMaxY = 0

    map.offsetX = 0
    map.offsetY = 0
    map.maxOffsetX = 0
    map.maxOffsetY = 0

    map.mapPauseClick = 0

        map.multiTouchX = -1
        map.multiTouchY = -1
    ResetWaterSourceSprites()
    ResetWaterGoalSprites()
    ResetWaterDropletSprites()
    ResetBombSprites()

    rem reset scroll offset position
    setspriteposition(403,90,220)

    for i = 0 to 319
        mapRowCheck[i] = 1
    next i

endfunction

function ResetWaterDroplets()
    i as integer
    for i = 0 to 1998
        mapWaterDroplets[i].active = 0
    next i
endfunction
function ResetLevelRankScores()
    i as integer
    for i = 0 to 5
        levelRankScores[i] = 0
    next
endfunction

function GetLevelRank(pScore as integer)
    myReturn as string

    if pScore > levelRankScores[0]
        myReturn = "S"
    elseif pScore > levelRankScores[1]
        myReturn = "A"
    elseif pScore > levelRankScores[2]
        myReturn = "B"
    elseif pScore > levelRankScores[3]
        myReturn = "C"
    elseif pScore > levelRankScores[4]
        myReturn = "D"
    else
        myReturn = "E"
    endif

endfunction myReturn
rem create droplets
rem this is done at start time.
rem we reset and hide our droplets at the start of each frame, but before we can do that we need to create them
function CreateDroplets()
    i as integer

    if map.mapMadeDroplets < map.mapDroplets
        for i = 0 to map.arrayWaterSourceCount
            if map.mapMadeDroplets < map.mapDroplets
                if VerifyPixelAtLocation(mapWaterSource[i].sourceX, mapWaterSource[i].sourceY) = 0
                    map.mapMadeDroplets = map.mapMadeDroplets + 1
                    SetPixelAtLocation(mapWaterSource[i].sourceX, mapWaterSource[i].sourceY, 2)
                    mapWaterDroplets[map.mapMadeDroplets - 1].X = mapWaterSource[i].sourceX
                    mapWaterDroplets[map.mapMadeDroplets - 1].Y = mapWaterSource[i].sourceY
                    mapWaterDroplets[map.mapMadeDroplets - 1].active = 1

                    mapWaterDroplets[map.mapMadeDroplets - 1].id = GetWaterDropletSpriteID(mapWaterSource[i].sourceX, mapWaterSource[i].sourceY)
                endif
            endif
        next
    endif
endfunction


rem update droplets
rem this is the AI for our game
function UpdateDroplets()
    i as integer
    x as integer
    y as integer
    tX as integer
    tY as integer
    tVerify as integer
    tRandom as float
    tHitLeft as integer
    tHitRight as integer
    tMoved as integer

    tMoved = 0

    for i =  0  to (map.mapMadeDroplets - 1)
        if mapWaterDroplets[i].active = 1
            x = mapWaterDroplets[i].X
            y = mapWaterDroplets[i].Y
            tX = mapWaterDroplets[i].X
            tY = mapWaterDroplets[i].Y + 1

            tVerify = VerifyPixelAtLocation(tX, tY)
            rem handle gravity
            if tVerify = 0
                rem hit nothing.  move down
                SetPixelAtLocation(x, y, 0)
                SetPixelAtLocation(tX, tY, 2)
                mapWaterDroplets[i].X = tX
                mapWaterDroplets[i].Y = tY
                tMoved = 1
                `SortWaterDroplets()
            elseif tVerify = 3
                rem hit goal
                 mapWaterDroplets[i].active = 0
                 map.mapGoalDroplets = map.mapGoalDroplets + 1
                 SetSpriteVisible(mapWaterDroplets[i].id, 0)
                 SetPixelAtLocation(x, y, 0)
                  map.levelTimeLastDroplet = map.mapCurrentSystemTime
                  tMoved = 1
            elseif tVerify = -1
                rem hit invalid area
                mapWaterDroplets[i].active = 0
                map.mapLostDroplets = map.mapLostDroplets + 1
                SetPixelAtLocation(x, y, 0)
                SetSpriteVisible(mapWaterDroplets[i].id, 0)
                tMoved = 1
            elseif tVerify = 1 or tVerify = 2
                rem move left or right
                rem since we hit solid or water

                rem reset positioning
                tX = x
                tY = y


                tRandom = Random(1,2)
                tHitLeft = VerifyPixelAtLocation(tX - 1, tY)
                tHitRight = VerifyPixelAtLocation(tX + 1, tY)

                `if tRandom < -1
                rem move left
                `if (tRandom > 32767.5 and tHitLeft <> 1 and tHitLeft <> 2) or (tHitRight = 1 or tHitRight = 2)
                if tRandom = 1
                    tX = x - 1
                    if tHitLeft = 0
                        mapWaterDroplets[i].X = tX
                        SetPixelAtLocation(x, y, 0)
                        SetPixelAtLocation(tX, tY, 2)
                        tMoved = 1
                    elseif tHitLeft = 3
                        mapWaterDroplets[i].active = 0
                        mapWaterDroplets[i].X = tX
                        map.mapGoalDroplets = map.mapGoalDroplets + 1
                        SetPixelAtLocation(x, y, 0)
                                      map.levelTimeLastDroplet = map.mapCurrentSystemTime
                         SetSpriteVisible(mapWaterDroplets[i].id, 0)
                         tMoved = 1
                    elseif tHitLeft = -1
                        mapWaterDroplets[i].active = 0
                        mapWaterDroplets[i].X = tX
                        map.mapLostDroplets = map.mapLostDroplets + 1
                        SetPixelAtLocation(x, y, 0)
                     SetSpriteVisible(mapWaterDroplets[i].id, 0)
                     tMoved = 1
                    endif
                else
                    tX = x + 1
                    if tHitRight = 0
                        mapWaterDroplets[i].X = tX
                        SetPixelAtLocation(x, y, 0)
                        SetPixelAtLocation(tX, tY, 2)
                        tMoved = 1
                    elseif tHitRight = 3
                        mapWaterDroplets[i].active = 0
                        mapWaterDroplets[i].X = tX
                                          map.levelTimeLastDroplet = map.mapCurrentSystemTime
                        map.mapGoalDroplets = map.mapGoalDroplets + 1
                        SetPixelAtLocation(x, y, 0)
                        tMoved = 1
                         SetSpriteVisible(mapWaterDroplets[i].id, 0)
                    elseif tHitRight = -1
                        mapWaterDroplets[i].active = 0
                        mapWaterDroplets[i].X = tX
                        map.mapLostDroplets = map.mapLostDroplets + 1
                        SetPixelAtLocation(x, y, 0)
                         SetSpriteVisible(mapWaterDroplets[i].id, 0)
                         tMoved = 1
                    endif
                endif
            endif

            SetSpritePosition(mapWaterDroplets[i].id, (mapWaterDroplets[i].X * 2) + 160 - map.offsetX, (mapWaterDroplets[i].Y * 2) - map.offsetY)
        `else
        `    i = map.mapMadeDroplets
        endif

    next

    if tMoved = 0
        map.mapDropletsNotMovedStep = map.mapDropletsNotMovedStep + 1
    else
        map.mapDropletsNotMovedStep = 0
    endif

    SortWaterDroplets()

endfunction

rem helper function that sets a map pixel to a certain value
rem returns 0 if failed, 1 if success
function SetPixelAtLocation(pX as integer, pY as integer, pValue as integer)
    myReturn as integer
    myReturn = 0

    if pX >= 0 and pX < map.mapWidth and pY >= 0 and pY < map.mapHeight
        mapPixelData[pX, pY] = pValue
        myReturn = 1
    endif
endfunction myReturn

rem helper function that returns a map pixel's value
rem returns -1 if invalid, 0 if transparent, 1 as solid, 2 as water, 3 as goal
function VerifyPixelAtLocation(pX as integer, pY as integer)
    myReturn as integer
    myReturn = 1

    if pX < 0 or pX >= map.mapWidth or pY < 0 or pY >= map.mapHeight
        myReturn = -1
    else
        `if IsSpotDropletOccupied(pX, pY, pI) = 0
            myReturn = mapPixelData[pX, pY]
        `else
        `    myReturn = 2
        `endif
    endif
endfunction myReturn

rem apply bomb to map pixels
rem this sets the data to the map to be erased
rem so water can flow through
function ApplyBombToPixels(pX as integer, pY as integer)
    i as integer
    j as integer
    tX as integer
    tY as integer

    rem since the map is really doubled
    rem multiply coordiate locations by half
    tX = pX * .5
    tY = pY * .5

SetBombAtLocationPixels(tX - 1, tY - 5)
SetBombAtLocationPixels(tX , tY - 5)
SetBombAtLocationPixels(tX + 1, tY - 5)
SetBombAtLocationPixels(tX - 3, tY - 4)
SetBombAtLocationPixels(tX - 2, tY - 4)
SetBombAtLocationPixels(tX - 1, tY - 4)
SetBombAtLocationPixels(tX , tY - 4)
SetBombAtLocationPixels(tX + 1, tY - 4)
SetBombAtLocationPixels(tX + 2, tY - 4)
SetBombAtLocationPixels(tX + 3, tY - 4)
SetBombAtLocationPixels(tX - 4, tY - 3)
SetBombAtLocationPixels(tX - 3, tY - 3)
SetBombAtLocationPixels(tX - 2, tY - 3)
SetBombAtLocationPixels(tX - 1, tY - 3)
SetBombAtLocationPixels(tX , tY - 3)
SetBombAtLocationPixels(tX + 1, tY - 3)
SetBombAtLocationPixels(tX + 2, tY - 3)
SetBombAtLocationPixels(tX + 3, tY - 3)
SetBombAtLocationPixels(tX + 4, tY - 3)
SetBombAtLocationPixels(tX - 4, tY - 2)
SetBombAtLocationPixels(tX - 3, tY - 2)
SetBombAtLocationPixels(tX - 2, tY - 2)
SetBombAtLocationPixels(tX - 1, tY - 2)
SetBombAtLocationPixels(tX , tY - 2)
SetBombAtLocationPixels(tX + 1, tY - 2)
SetBombAtLocationPixels(tX + 2, tY - 2)
SetBombAtLocationPixels(tX + 3, tY - 2)
SetBombAtLocationPixels(tX + 4, tY - 2)
SetBombAtLocationPixels(tX - 5, tY - 1)
SetBombAtLocationPixels(tX - 4, tY - 1)
SetBombAtLocationPixels(tX - 3, tY - 1)
SetBombAtLocationPixels(tX - 2, tY - 1)
SetBombAtLocationPixels(tX - 1, tY - 1)
SetBombAtLocationPixels(tX , tY - 1)
SetBombAtLocationPixels(tX + 1, tY - 1)
SetBombAtLocationPixels(tX + 2, tY - 1)
SetBombAtLocationPixels(tX + 3, tY - 1)
SetBombAtLocationPixels(tX + 4, tY - 1)
SetBombAtLocationPixels(tX + 5, tY - 1)
SetBombAtLocationPixels(tX - 5, tY )
SetBombAtLocationPixels(tX - 4, tY )
SetBombAtLocationPixels(tX - 3, tY )
SetBombAtLocationPixels(tX - 2, tY )
SetBombAtLocationPixels(tX - 1, tY )
SetBombAtLocationPixels(tX , tY )
SetBombAtLocationPixels(tX + 1, tY )
SetBombAtLocationPixels(tX + 2, tY )
SetBombAtLocationPixels(tX + 3, tY )
SetBombAtLocationPixels(tX + 4, tY )
SetBombAtLocationPixels(tX + 5, tY )
SetBombAtLocationPixels(tX - 5, tY + 1)
SetBombAtLocationPixels(tX - 4, tY + 1)
SetBombAtLocationPixels(tX - 3, tY + 1)
SetBombAtLocationPixels(tX - 2, tY + 1)
SetBombAtLocationPixels(tX - 1, tY + 1)
SetBombAtLocationPixels(tX , tY + 1)
SetBombAtLocationPixels(tX + 1, tY + 1)
SetBombAtLocationPixels(tX + 2, tY + 1)
SetBombAtLocationPixels(tX + 3, tY + 1)
SetBombAtLocationPixels(tX + 4, tY + 1)
SetBombAtLocationPixels(tX + 5, tY + 1)
SetBombAtLocationPixels(tX - 4, tY + 2)
SetBombAtLocationPixels(tX - 3, tY + 2)
SetBombAtLocationPixels(tX - 2, tY + 2)
SetBombAtLocationPixels(tX - 1, tY + 2)
SetBombAtLocationPixels(tX , tY + 2)
SetBombAtLocationPixels(tX + 1, tY + 2)
SetBombAtLocationPixels(tX + 2, tY + 2)
SetBombAtLocationPixels(tX + 3, tY + 2)
SetBombAtLocationPixels(tX + 4, tY + 2)
SetBombAtLocationPixels(tX - 4, tY + 3)
SetBombAtLocationPixels(tX - 3, tY + 3)
SetBombAtLocationPixels(tX - 2, tY + 3)
SetBombAtLocationPixels(tX - 1, tY + 3)
SetBombAtLocationPixels(tX , tY + 3)
SetBombAtLocationPixels(tX + 1, tY + 3)
SetBombAtLocationPixels(tX + 2, tY + 3)
SetBombAtLocationPixels(tX + 3, tY + 3)
SetBombAtLocationPixels(tX + 4, tY + 3)
SetBombAtLocationPixels(tX - 3, tY + 4)
SetBombAtLocationPixels(tX - 2, tY + 4)
SetBombAtLocationPixels(tX - 1, tY + 4)
SetBombAtLocationPixels(tX , tY + 4)
SetBombAtLocationPixels(tX + 1, tY + 4)
SetBombAtLocationPixels(tX + 2, tY + 4)
SetBombAtLocationPixels(tX + 3, tY + 4)
SetBombAtLocationPixels(tX - 1, tY + 5)
SetBombAtLocationPixels(tX , tY + 5)
SetBombAtLocationPixels(tX + 1, tY + 5)

    remstart
    SetBombAtLocationPixels(tX, tY - 3)
    SetBombAtLocationPixels(tX + 1, tY - 3)

    SetBombAtLocationPixels(tX - 2, tY - 2)
    SetBombAtLocationPixels(tX - 1, tY - 2)
    SetBombAtLocationPixels(tX, tY - 2)
    SetBombAtLocationPixels(tX + 1, tY - 2)
    SetBombAtLocationPixels(tX + 2, tY - 2)
    SetBombAtLocationPixels(tX + 3, tY - 2)

    SetBombAtLocationPixels(tX - 2, tY - 1)
    SetBombAtLocationPixels(tX - 1, tY - 1)
    SetBombAtLocationPixels(tX, tY - 1)
    SetBombAtLocationPixels(tX + 1, tY - 1)
    SetBombAtLocationPixels(tX + 2, tY - 1)
    SetBombAtLocationPixels(tX + 3, tY - 1)

    SetBombAtLocationPixels(tX - 3, tY)
    SetBombAtLocationPixels(tX - 2, tY)
    SetBombAtLocationPixels(tX - 1, tY)
    SetBombAtLocationPixels(tX, tY)
    SetBombAtLocationPixels(tX + 1, tY)
    SetBombAtLocationPixels(tX + 2, tY)
    SetBombAtLocationPixels(tX + 3, tY)
    SetBombAtLocationPixels(tX + 4, tY)

    SetBombAtLocationPixels(tX - 3, tY + 1)
    SetBombAtLocationPixels(tX - 2, tY + 1)
    SetBombAtLocationPixels(tX - 1, tY + 1)
    SetBombAtLocationPixels(tX, tY + 1)
    SetBombAtLocationPixels(tX + 1, tY + 1)
    SetBombAtLocationPixels(tX + 2, tY + 1)
    SetBombAtLocationPixels(tX + 3, tY + 1)
    SetBombAtLocationPixels(tX + 4, tY + 1)

    SetBombAtLocationPixels(tX - 2, tY + 2)
    SetBombAtLocationPixels(tX - 1, tY + 2)
    SetBombAtLocationPixels(tX, tY + 2)
    SetBombAtLocationPixels(tX + 1, tY + 2)
    SetBombAtLocationPixels(tX + 2, tY + 2)
    SetBombAtLocationPixels(tX + 3, tY + 2)

    SetBombAtLocationPixels(tX - 2, tY + 3)
    SetBombAtLocationPixels(tX - 1, tY + 3)
    SetBombAtLocationPixels(tX, tY + 3)
    SetBombAtLocationPixels(tX + 1, tY + 3)
    SetBombAtLocationPixels(tX + 2, tY + 3)
    SetBombAtLocationPixels(tX + 3, tY + 3)

    SetBombAtLocationPixels(tX, tY + 4)
    SetBombAtLocationPixels(tX + 1, tY + 4)
    remend
endfunction

rem this is basically a modified version of the setPixelMapValue function
rem except we only want to erase '1' values.  it'd suck if we accidentally
rem destroyed the areas of the map that the goals are at
function SetBombAtLocationPixels(pX as integer, pY as integer)
    myReturn as integer
    myReturn = 1

    if pX >= 0 and pX < map.mapWidth and pY >= 0 and pY < map.mapHeight
        if mapPixelData[pX, pY] = 1
            mapPixelData[pX, pY] = 0
        endif
    endif
endfunction

rem update all sprites on the playfield by the map offset
function UpdatePlayfieldSprites()
    rem map
    SetSpritePosition(SpriteMap, 160 - map.offsetX, -1 * map.offsetY)

    rem water source arrows
    i as integer
    for i = 0 to map.arrayWaterSourceCount
        SetSpritePosition(mapWaterSource[i].spriteID, mapWaterSource[i].spriteX - map.offsetX + 160, mapWaterSource[i].spriteY - map.offsetY)
    next

    rem water goal arrows
    for i = 0 to map.arrayWaterGoalCount
        SetSpritePosition(mapWaterGoal[i].spriteID, mapWaterGoal[i].spriteX - map.offsetX + 160, mapWaterGoal[i].spriteY - map.offsetY)
    next

    rem bombs - e.g., black circles
    for i = 0 to map.arrayBombCount
       SetSpritePositionByOffset(mapBomb[i].spriteID, mapBomb[i].spriteX - map.offsetX + 160, mapBomb[i].spriteY - map.offsetY)
    next
endfunction

rem this function determines the offset the map should have
rem based on user input on the screen
function DetermineMapOffset(pX as float, pY as float)
    rem min X on screen is 90, max x is 137
    rem min y on screen is 220, max y is 291

    rem check to see if the player input is within the scroll box range
    rem subtract a lil from the top and left values so that the scrolling is easier to do

    if pX >= 80 and pX <= 137 and pY >= 210 and pY <=291
        rem ignore presses if we can't do an X offset
        rem out of bounds
        if map.maxOffsetX = 0 and pX > 115
            exitfunction
        endif
        rem same for y value
        if map.maxOffsetY = 0 and pY > 251
            exitfunction
        endif

        rem increase range back to normal values
        rem this is so that scrolling back to 0,0 isn't so picky, this allows us room for error
        if pX < 90
            pX = 90
        endif

        if pY < 220
            pY = 220
        endif

        if pX > 114
            pX = 114
        endif

        rem determine X offset
        if map.maxOffsetX <> 0
            rem remember to double since the screen is doubled
            map.offsetX = ((pX-90) / 24) * 160

            rem if the offset is greater than max offset, bring it back down
            if map.offsetX > map.maxOffsetX
                map.offsetX = map.maxOffsetX
            endif

            rem double offset since the map is doubled
            map.offsetX = map.offsetX * 2
            rem update box sprite so the user knows where the offset is currently located
            SetSpriteX(403, pX)
        endif

        rem ignore presses if we can't do a y offset
        if map.maxOffsetY <> 0
            rem we handle things differently depending on the vertical size of the map
            rem 160, 320 or 480

            rem map size is really 320
            if map.maxOffsetY = 160

                rem ignore mosue clicks over 244
                if pY > 244
                    pY = 244
                endif

                rem determine offset
                map.offsetY = ((pY-220) / 24) * 160
                rem set square hover box again
                SetSpriteY(403, pY)

                rem check offset to make sure its in correct bounds
                if map.offsetY > map.maxOffsetY
                    map.offsetY = map.maxOffsetY
                endif
                map.offsetY = map.offsetY * 2
            else
                rem now do the same for playfields that are 480 in size

                if pY > 268
                    pY = 268
                endif

                map.offsetY = ((pY-220) / 48) * 320
                SetSpriteY(403, pY)

                if map.offsetY > map.maxOffsetY
                    map.offsetY = map.maxOffsetY
                endif
                map.offsetY = map.offsetY * 2
            endif


        endif
    endif

endfunction

function CreateBomb(pX as integer, pY as integer)
    rem create bomb sprite.
    tX as integer
    tY as integer
    tX = pX + map.offsetX
    tY = pY + map.offsetY

    rem since map is scaled (doubled) we onyl want sprites to be placed on even numbers
    tX = tX - mod(tX, 2)
    tY = tY - mod(tY, 2)

    rem update bomb count counters
    sfBombCount = sfBombCount + 1
    map.arrayBombCount = map.arrayBombCount + 1
    map.mapDroppedBombs = map.mapDroppedBombs + 1
    rem redim bomb array so we can access the sprites later for offsetting
    dim mapBomb[map.arrayBombCount + 1] as TYPE_BOMB
    rem assign sprite id to a newly created sprite
    mapBomb[map.arrayBombCount].spriteID = GetBombSpriteID(tX, tY)
    rem actually now assign the bomb to the data behind the map
    ApplyBombToPixels(tX, tY)

    playMediaFX(1)
    rem make sure all of the bomb pixel information is entered into the array
    mapBomb[map.arrayBombCount].x = tX * .5
    mapBomb[map.arrayBombCount].y = tY * .5
    mapBomb[map.arrayBombCount].spriteX = tX
    mapBomb[map.arrayBombCount].spriteY = tY `pY + map.offsetY
endfunction

rem main game loop
function GameplayLoop(pointerX as integer, pointerY as integer)
    i as integer
    rem mapstate
    rem 0 = start
    rem 1 = active
    rem 2 = paused
    rem 3 = failed
    rem 4 = finished
    if map.mapState = 0
        rem level start, click to start
        UpdateGameplayGUI(pointerX, pointerY, 0)

        if GetPointerReleased() = 1
            map.mapState = 1
            playMediaFX(3)
            SetSpriteVisible(404,0)
        else
            SetSpriteVisible(404,1)
        endif
    elseif map.mapState = 1
        rem check to see if the game is paused
        rem however we want to make sure that the person clicks in pause before we do that
        rem so we prevent accidental pausing when using the scrollbar

        rem set value if pointer is pressed within the "pause" button area
        if GetPointerPressed() = 1
            if CheckButtonPointerHover(410, pointerX, pointerY, 10, 10)
                map.mapPauseClick = 1
            else
                map.mapPauseClick = 0
            endif
        endif

        rem check if the pointer was only clicked within the pause area
        if map.mapPauseClick = 1
            rem check to see if pointer was also released within the pause area
            if GetPointerReleased() = 1
                if CheckButtonPointerHover(410, pointerX, pointerY, 10, 10)
                    rem set game to pause mode
                    map.mapState = 2
                    playMediaFX(3)
                endif
            endif
        endif

        rem if the user paused gameplay, stop playing
        if map.mapState = 1
            rem gameplay
            HandleGameplay(pointerX, pointerY)

            rem check to see if level failed
            if ((map.mapCurrentPrepTime <= 0 and map.mapCurrentSystemTime <=0) or map.mapAltFinished = 1) and map.mapGoalDroplets < map.mapRequiredDroplets
                rem level is failed
                map.mapState = 3
                SetSpriteVisible(406,1)
            elseif ((map.mapCurrentPrepTime <= 0 and map.mapCurrentSystemTime <=0) or map.mapAltFinished = 1) and map.mapGoalDroplets >= map.mapRequiredDroplets
                rem level is finished successfully
                computePlayerScore()
                map.mapState = 4
            elseif map.mapGoalDroplets = map.mapDroplets
                rem level is finished successfully - perfect score!
                computePlayerScore()
                map.mapState = 4
            endif
        endif
    elseif map.mapState = 2
        rem set pause button to regular font
        `SetTextFontImage(410,0)
        `SetTextFontImage(410, 7)
        SetTextColor(410,255,255,255,255)
        rem game is paused
        SetSpriteVisible(405, 1)

        for i = 420 to 423
            SetTextVisible(i, 1)
            CheckButtonPointerHover(i, pointerX, pointerY, 10, 10)
        next i

        if map.mapCurrentPrepTime = 0
            SetTextVisible(423, 0)
        endif

        rem make sure there was a click
        if GetPointerReleased() = 1
            rem resume game
            if CheckButtonPointerHover(420, pointerX, pointerY, 10, 10) = 1
                rem resume game, set map state to normal and hide pause screen
                map.mapState = 1
                SetSpriteVisible(405, 0)

                rem hide menu options
                    SetTextVisible(420, 0)
                    SetTextVisible(421, 0)
                    SetTextVisible(422, 0)
                    SetTextVisible(423, 0)
                playMediaFX(3)

            endif

            rem flood stage
            if gettextvisible(423) = 1
                if CheckButtonPointerHover(423, pointerX, pointerY, 10, 10) = 1
                    rem resume game, set map state to normal and hide pause screen
                    map.mapState = 1
                    SetSpriteVisible(405, 0)

                    rem hide menu options
                    SetTextVisible(420, 0)
                    SetTextVisible(421, 0)
                    SetTextVisible(422, 0)
                    SetTextVisible(423, 0)
                    playMediaFX(3)

                    map.mapCurrentPrepTime = 0
                endif
            endif

            rem restart level
            if CheckButtonPointerHover(421, pointerX, pointerY, 10, 10)
                rem restart level
                rem hide pause screen sprite
                SetSpriteVisible(405, 0)
                    SetTextVisible(420, 0)
                    SetTextVisible(421, 0)
                    SetTextVisible(422, 0)
                    SetTextVisible(423, 0)
                                SetTextVisible(423, 0)
                rem reload map
                LoadMapFromFile()
                rem set click start graphic visible
                SetSpriteVisible(404, 1)
                playMediaFX(3)
            endif

            rem main menu
            if CheckButtonPointerHover(422, pointerX, pointerY, 10, 10)
                rem restart level
                rem hide pause screen sprite
                remstart
                SetSpriteVisible(405, 0)
                SetTextVisible(420, 0)
                SetTextVisible(421, 0)
                SetTextVisible(422, 0)
                rem reload map
                levelSelected = levelSelected + 1
                LoadMapFromFile()
                rem set click start graphic visible
                SetSpriteVisible(404, 1)
                remend

                remstart
                menuState = 4
                HideGameplayGUI()
                playMediaMenu()
                setLevelSelectScrollVisible(1)
                remend

playMediaFX(3)

                if CanShowFinishAllSRank() = 1
                    shownCompletedAllLevels = 1
                    shownCompletedAllSRank = 1
                    HideGameplayGUI()
                    menuState = 7
                    SetCongratsGUIVisible(1, 1)
                elseif CanShowFinishAllLevels() = 1
                    shownCompletedAllLevels = 1
                    HideGameplayGUI()
                    menuState = 7
                    SetCongratsGUIVisible(1, 0)
                else
                    rem do normal
                    menuState = 4
                    HideGameplayGUI()
                    playMediaMenu()
                    setLevelSelectScrollVisible(1)
                endif

            endif
        endif
    elseif map.mapState = 3
        rem level failed
        rem set pause button to regular font
        `SetTextFontImage(410, 0)
        `SetTextFontImage(410, 7)
        SetTextColor(410,255,255,255,255)
        rem display level failed text
        SetSpriteVisible(406, 1)

        for i = 421 to 422
            SetTextVisible(i, 1)
            CheckButtonPointerHover(i, pointerX, pointerY, 10, 10)
        next i

        if GetPointerReleased() = 1
            rem restart level
            if CheckButtonPointerHover(421, pointerX, pointerY, 10, 10)
                rem restart level
                rem hide fail screen sprite
                SetSpriteVisible(406, 0)
                rem reload map
                LoadMapFromFile()
                rem set click start graphic visible
                SetSpriteVisible(404, 1)
                rem hide text
                SetTextVisible(421, 0)
                SetTextVisible(422, 0)
                playMediaFX(3)
            endif

            if CheckButtonPointerHover(422, pointerX, pointerY, 10, 10)
                for i = 411 to 419
                    SetTextVisible(i, 0)
                next
                SetSpriteVisible(407, 0)
                SetSpriteVisible(408, 0)

                remstart
                        menuState = 4
                HideGameplayGUI()
                playMediaMenu()
                setLevelSelectScrollVisible(1)
                remend
                playMediaFX(3)
                                if CanShowFinishAllSRank() = 1
                    shownCompletedAllLevels = 1
                    shownCompletedAllSRank = 1
                    HideGameplayGUI()
                    menuState = 7
                    SetCongratsGUIVisible(1, 1)
                elseif CanShowFinishAllLevels() = 1
                    shownCompletedAllLevels = 1
                    HideGameplayGUI()
                    menuState = 7
                    SetCongratsGUIVisible(1, 0)
                else
                    rem do normal
                    menuState = 4
                    HideGameplayGUI()
                    playMediaMenu()
                    setLevelSelectScrollVisible(1)
                endif

            endif
        endif
    elseif map.mapState = 4
        rem stage clear
        for i = 418 to 419
            CheckButtonPointerHover(i, pointerX, pointerY, 10, 10)
        next

        if GetPointerReleased() = 1
            rem player wants to play the stage again
            if CheckButtonPointerHover(418, pointerX, pointerY, 10, 10) = 1
                for i = 411 to 419
                    SetTextVisible(i, 0)
                next
                SetSpriteVisible(407, 0)
                SetSpriteVisible(408, 0)
                rem show click to play sprite again
                SetSpriteVisible(404,1)
                LoadMapFromFile()
                playMediaFX(3)
            endif
        endif

        if GetPointerReleased() = 1
            rem player wants to go back to the main menu
            if CheckButtonPointerHover(419, pointerX, pointerY, 10, 10) = 1
                for i = 411 to 419
                    SetTextVisible(i, 0)
                next
                SetSpriteVisible(407, 0)
                SetSpriteVisible(408, 0)

                playMediaFX(3)

                if CanShowFinishAllSRank() = 1
                    shownCompletedAllLevels = 1
                    shownCompletedAllSRank = 1
                    HideGameplayGUI()
                    menuState = 7
                    SetCongratsGUIVisible(1, 1)
                elseif CanShowFinishAllLevels() = 1
                    shownCompletedAllLevels = 1
                    HideGameplayGUI()
                    menuState = 7
                    SetCongratsGUIVisible(1, 0)
                else
                    rem do normal
                    menuState = 4
                    HideGameplayGUI()
                    playMediaMenu()
                    setLevelSelectScrollVisible(1)
                endif
            endif
        endif

        remstart

        remend
    endif

endfunction

function HandleGameplay(pointerX as integer, pointerY as integer)
    rem temp values so we can update
    rem cursor values later
    tX as float
    tY as float
    tIndex as float
    tCount as float
    tReleased as integer

    tIndex = 0
    tCount = 0

    rem update game clock
    rem once user prep time is finished, go to system time.
    rem once system time is up - or perfect finish - level is over
        if map.mapCurrentPrepTime <> 0
            map.mapCurrentPrepTime = SubtractTimePlaySound(map.mapCurrentPrepTime)
            if map.mapCurrentPrepTime < 0 or (map.mapBombs - map.mapDroppedBombs = 0)
                map.mapCurrentPrepTime = 0
            endif
        endif

        if map.mapCurrentSystemTime <> 0 and map.mapCurrentPrepTime = 0
            map.mapCurrentSystemTime = SubtractTimePlaySound(map.mapCurrentSystemTime)
            if map.mapCurrentSystemTime < 0
                map.mapCurrentSystemTime = 0
            elseif map.mapMadeDroplets = (map.mapGoalDroplets + map.mapLostDroplets) and map.mapMadeDroplets > 0
                map.levelTimeLastDroplet = map.mapCurrentSystemTime
                map.mapAltFinished = 1
            elseif map.mapDropletsNotMovedStep > 8
                map.levelTimeLastDroplet = map.mapCurrentSystemTime
                map.mapAltFinished = 1
            endif
        endif

        remstart
        if GetMultiTouchExists() = 1
            tIndex = GetRawFirstTouchEvent(1)

            while tIndex <> 0
                tX = tX + GetRawTouchCurrentX(tIndex)
                tY = tY + GetRawTouchCurrentY(tIndex)
                tCount = tCount + 1
                tReleased = tReleased + GetRawTouchReleased(tIndex)
                tIndex = GetRawNextTouchEvent()
            endwhile
        endif
        remend

        rem only place bombs if time is valid and cursor is above 0
        if map.mapCurrentPrepTime > 0
            if GetMultiTouchExists() = 1

                if touchInput.touchCount >= 2
                    if map.mapDroppedBombs < map.mapBombs
                        rem we only want to set values if we have two fingers touching the screen at once

                            tX = pointerX - 160
                            tY = pointerY

                            map.multiTouchX = tX
                            map.multiTouchY = tY

                            SetSpriteVisible(SpriteTargetingArrow,1)
                            SetSpritePositionByOffset(SpriteTargetingArrow,map.multiTouchX + 160, map.multiTouchY)
                        `endif

                        rem now release bombs
                        if touchInput.touchReleased >= 1 and map.multiTouchX <> -1
                                CreateBomb(map.multiTouchX, map.multiTouchY)
                                map.multiTouchX = -1
                                map.multiTouchY = -1
                                SetSpriteVisible(SpriteTargetingArrow,0)
                        endif

                    else
                        tX = pointerX - 160
                            if tX >= 0 and GetPointerPressed() = 1
                                if GetSoundsPlaying(2) = 0
                                    playMediaFX(2)
                                endif
                            endif

                        SetSpriteVisible(SpriteTargetingArrow, 0)
                    endif

                    touchInput.touchBomb = 1
                elseif touchInput.touchCount = 1 and touchInput.touchReleased = 0 and touchInput.touchBomb = 0
                    UpdateMultitouchOffset(pointerX, pointerY)
                else
                    if getPointerState() = 0
                        touchInput.touchBomb = 0
                    endif

                    SetSpriteVisible(SpriteTargetingArrow, 0)
                endif

            else

                tX = pointerX - 160
                tY = pointerY
                if tX >= 0
                    if GetPointerState() = 1 and map.mapDroppedBombs < map.mapBombs
                        SetSpriteVisible(SpriteTargetingArrow,1)
                        SetSpritePositionByOffset(SpriteTargetingArrow, tX + 160, tY)
                    else
                        SetSpriteVisible(SpriteTargetingArrow, 0)
                    endif

                    if GetPointerReleased() = 1
                        if map.mapDroppedBombs < map.mapBombs
                            CreateBomb(tX, tY)
                        else
                            playMediaFX(2)
                        endif
                    endif
                endif
            endif
        else
            if GetMultiTouchExists() = 0 or touchInput.touchCount >= 2
                if GetPointerReleased() = 1
                    if pointerX >= 160
                         playMediaFX(2)
                    endif
                endif
            else
                UpdateMultiTouchOffset(pointerX, pointerY)
            endif
        endif


     rem mosue is pointed downward, check to see if we can do map offset
    if GetMultiTouchExists() = 0
        if GetPointerState() = 1
            DetermineMapOffset(pointerX, pointerY)
        endif
    endif

    rem update sprites on the field according to offset
    UpdatePlayfieldSprites()


        rem only update droplets if time is valid
        if map.mapCurrentPrepTime = 0 and map.mapCurrentSystemTime > 0
            SetSpriteVisible(SpriteTargetingArrow, 0)
            CreateDroplets()
            UpdateDroplets()
        endif

    `SortWaterDroplets()

    UpdateGameplayGUI(pointerX, pointerY, 1)
endfunction

function UpdateMultiTouchOffset(pointerX as integer, pointerY as integer)
    if pointerX > 160
    if GetPointerPressed() = 1
        touchInput.X1 = pointerX
        touchInput.Y1 = pointerY
    elseif GetPointerState() = 1
        touchInput.X2 = pointerX
        touchInput.Y2 = pointerY

        if map.maxOffsetX > 0
            map.offsetX = map.offsetX + (touchInput.X1 - touchInput.X2)

            if map.offsetX < 0
                map.offsetX = 0
            endif

            if map.offsetX > map.maxOffsetX  + 160
                map.offsetX = map.maxOffsetX  + 160
            endif
        endif

        if map.maxOffsetY > 0
            map.offsetY = map.offsetY + (touchInput.Y1 - touchInput.Y2)

            if map.offsetY < 0
                map.offsetY = 0
            endif

            if map.mapHeight <= 320
                if map.offsetY > map.maxOffsetY + 160
                    map.offsetY = map.maxOffsetY + 160
                endif
            elseif map.mapHeight = 480
                if map.offsetY > map.maxOffsetY + 320
                    map.offsetY = map.maxOffsetY + 320
                endif
            endif
        endif

        touchInput.X1 = pointerX
        touchInput.Y1 = pointerY
    else
        touchInput.X1 = 0
        touchInput.Y1 = 0
    endif


    SetSpriteVisible(SpriteTargetingArrow, 0)
    SetSpritePosition(403, 90 + (map.offsetX * 0.075), 220 + (map.offsetY * 0.075))

    endif
endfunction

function computePlayerScore()
    perfectClear as integer
    tTimeRemaining as float
    tText as string
    rem 407 sprite is clear
    rem 408 sprite is perfect clear

    rem determine if level is a perfect clear
    if map.mapGoalDroplets = map.mapDroplets
        perfectClear = 1
    endif

    rem set up screen for perfect clear
    rem text id is 414
    if perfectClear = 1
        map.levelPerfectBonus = 1500
        SetSpriteVisible(408, 1)
        tText = "Perfect Bonus" + FormatScoreString(str(trunc(map.levelPerfectBonus)))
        SetTextString(414, tText)

    else
        map.levelPerfectBonus = 0
        tText = "Perfect Bonus" + FormatScoreString(str(trunc(map.levelPerfectBonus)))
        SetTextString(414, tText)
        SetSpriteVisible(407, 1)
    endif

    rem score points for droplets collected
    rem text id is 411
    map.levelDropletBonus = map.mapGoalDroplets * 8
    tText = "Droplet Bonus" + FormatScoreString(str(trunc(map.levelDropletBonus)))
    SetTextString(411, tText)

    rem score points for time remaining
    rem text id is 412
    tTimeRemaining = map.levelTimeLastDroplet / map.mapSystemTime
    if tTimeRemaining < 0
        tTimeRemaining = 0
    endif
    map.levelTimeBonus = tTimeRemaining * 2500
    tText = "   Time Bonus" + FormatScoreString(str(trunc(map.levelTimeBonus)))
    SetTextString(412, tText)

    rem score points for bombs remaining
    rem text id is 413
    map.levelBombBonus = (map.mapBombs - map.mapDroppedBombs) * 500
    tText = "   Bomb Bonus" + FormatScoreString(str(trunc(map.levelBombBonus)))
    SetTextString(413, tText)

    rem add score up
    rem text id is 415
    map.levelScore = map.levelDropletBonus + map.levelTimeBonus + map.levelBombBonus + map.levelPerfectBonus
    tText = "  Total Score" + FormatScoreString(str(trunc(map.levelScore)))
    SetTextString(415, tText)

    rem compute rank
    rem text id is 416
    map.levelRank = GetLevelRank(map.levelScore)
    tText = "         Rank" + FormatScoreString(map.levelRank)
    SetTextString(416, tText)

    SetTextVisible(411, 1)
    SetTextVisible(412, 1)
    SetTextVisible(413, 1)
    SetTextVisible(414, 1)
    SetTextVisible(415, 1)
    SetTextVisible(416, 1)


    if updateHighScore(levelSelected, map.levelScore, map.levelRank) = 1
        SetTextVisible(417, 1)
    endif



    SetTextVisible(418, 1)
    SetTextVisible(419, 1)
endfunction

rem make sure that we keep the game honest now ;)
function GetModifiedFrameTime()
    myReturn as float
`    myReturn = GetTimeElapsed()
    myReturn = GetFrameTime()

    if myReturn > .01667
        myReturn = .01667
    endif

endfunction  myReturn

function SubtractTimePlaySound(pValue as float)
    myReturn as float
    myReturnOri as float
    i as integer

    myReturn = pValue
    myReturnOri = pValue

    myReturn = myReturn - GetModifiedFrameTime()

    for i = 0 to 5
        if myReturnOri >= i and myReturn =< i
            playMediaFX(3)
        endif
    next
endfunction myReturn

rem help get optimize the gameplay
function TransferRowCheck()
    i as integer
    for i = 0 to map.mapHeight - 1
        mapRowCheck[i] = newRowCheck[i]
        newRowCheck[i] = 0
    next
endfunction

function SetNewRowCheck(pValue as integer)
    if pValue >= 0 and pValue <= map.mapHeight
        newRowCheck[pValue] = 1
    endif
endfunction

function GetRowCheck(pRow as integer)
    myReturn as integer

    `if pRow >= 0 and pRow <= map.mapHeight - 1
        myReturn = mapRowCheck[pRow]
    `endif
endfunction myReturn

function SortWaterDroplets()
    swapped as integer
    i as integer

    repeat
        swapped = 0

        for i = 1 to map.mapMadeDroplets - 1
            `if mapWaterDroplets[i - 1].X > map.mapWaterDroplets[i].X

              if mapWaterDroplets[i - 1].active = 1 and mapWaterDroplets[i].active = 1
                    if mapWaterDroplets[i - 1].Y < mapWaterDroplets[i].Y
                     `   if mapWaterDroplets[i - 1].X > mapWaterDroplets[i].X

                        `else
                     `       SwapDroplets(i)
                     `       swapped = 1
                     `   endif
                    `else
                        SwapDroplets(i)
                        swapped = 1
                    elseif mapWaterDroplets[i - 1].Y = mapWaterDroplets[i].Y
                        if mapWaterDroplets[i - 1].X < mapWaterDroplets[i].X
                            SwapDroplets(i)
                            swapped = 1
                        endif
                    endif
                elseif mapWaterDroplets[i - 1].active = 0 and mapWaterDroplets[i].active = 1
                    SwapDroplets(i)
                    swapped = 1
                endif
            `endif
        next

        for i =  map.mapMadeDroplets - 1 to 1 step - 1

            remstart
            `if mapWaterDroplets[i - 1].X > map.mapWaterDroplets[i].X
                if mapWaterDroplets[i - 1].Y > mapWaterDroplets[i].Y
                 `   if mapWaterDroplets[i - 1].X > mapWaterDroplets[i].X

                    `else
                 `       SwapDroplets(i)
                 `       swapped = 1
                 `   endif
                `else
                    SwapDroplets(i)
                    swapped = 1
                elseif mapWaterDroplets[i - 1].Y = mapWaterDroplets[i].Y
                    if mapWaterDroplets[i - 1].X > mapWaterDroplets[i].X
                        SwapDroplets(i)
                        swapped = 1
                    endif
                endif
            `endif
            remend

                if mapWaterDroplets[i - 1].active = 1 and mapWaterDroplets[i].active = 1
                    if mapWaterDroplets[i - 1].Y < mapWaterDroplets[i].Y
                     `   if mapWaterDroplets[i - 1].X > mapWaterDroplets[i].X

                        `else
                     `       SwapDroplets(i)
                     `       swapped = 1
                     `   endif
                    `else
                        SwapDroplets(i)
                        swapped = 1
                    elseif mapWaterDroplets[i - 1].Y = mapWaterDroplets[i].Y
                        if mapWaterDroplets[i - 1].X < mapWaterDroplets[i].X
                            SwapDroplets(i)
                            swapped = 1
                        endif
                    endif
                elseif mapWaterDroplets[i - 1].active = 0 and mapWaterDroplets[i].active = 1
                    SwapDroplets(i)
                    swapped = 1
                endif

        next
    until swapped = 0

endfunction

function SwapDroplets(i as integer)
    tX as integer
    tY as integer
    tActive as integer
    tID as integer

    tX = mapWaterDroplets[i - 1].X
    tY = mapWaterDroplets[i - 1].Y
    tActive = mapWaterDroplets[i - 1].active
    tID = mapWaterDroplets[i - 1].id

    mapWaterDroplets[i - 1].X = mapWaterDroplets[i].X
    mapWaterDroplets[i - 1].Y = mapWaterDroplets[i].Y
    mapWaterDroplets[i - 1].active = mapWaterDroplets[i].active
    mapWaterDroplets[i - 1].id = mapWaterDroplets[i].id

    mapWaterDroplets[i].X = tX
    mapWaterDroplets[i].Y = tY
    mapWaterDroplets[i].active = tActive
    mapWaterDroplets[i].id = tID
endfunction
