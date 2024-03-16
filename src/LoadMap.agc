
function LoadMapFromFile()
    tempString as string
    tempType as string
    tempTypeValue as integer
    tempCount as integer
    tempReplaceData as integer

    x as integer
    y as integer
    i as integer

    ResetMap()
    rem open file
    opentoread(MapFileID, levelList[levelSelected].levelPath)
    map.mapPic = readline(MapFileID)

    rem load image for map and create sprite for it?
    deletesprite(SpriteMap)
    deleteimage(ImageMap)

    loadimage(ImageMap,map.mapPic,0)
    `SetImageMagFilter(ImageMap, 0)
    `SetImageMinFilter(ImageMap, 1)
    CreateSprite(SpriteMap,ImageMap)
    setspriteposition(SpriteMap,160,0)
    setspritevisible(SpriteMap, 1)
    SetSpritedepth(SpriteMap, 15)
    SetSpriteScale(SpriteMap, 2, 2)

    rem replace goal data
    tempReplaceData = val(readline(MapFileID))

    rem load prep time
    map.mapPrepTime = val(readline(MapFileID))
    map.mapCurrentPrepTime = map.mapPrepTime

    rem load system time
    map.mapSystemTime = val(readLine(MapFileID))
    map.mapCurrentSystemTime = map.mapSystemTime

    rem load required percentage
    map.mapRequiredDroplets = val(readline(MapFileID))

    rem load total droplets
    map.mapDroplets = val(readline(MapFileID))

    rem load total bombs player can use
    map.mapBombs = val(readline(MapFileID))

    rem lead in water source count into memory
    rem redim array
    map.arrayWaterSourceCount = val(readline(MapFileID))
    dim mapWaterSource[map.arrayWaterSourceCount + 1] AS TYPE_WATER_SOURCE

    rem now read in values for the water sources
    for i = 0 to map.arrayWaterSourceCount
        tempString = readline(MapFileID)

        rem store internal data where the original item was
        mapWaterSource[i].X = val(SplitString(tempString,",",0))
        mapWaterSource[i].Y = val(SplitString(tempString,",",1))

        rem store where the droplets actually spawn
        mapWaterSource[i].sourceX = mapWaterSource[i].X + 4
        mapWaterSource[i].sourceY = mapWaterSource[i].Y

        rem sprite positioning
        mapWaterSource[i].spriteX = mapWaterSource[i].X * 2
        mapWaterSource[i].spriteY = mapWaterSource[i].Y * 2

        mapWaterSource[i].spriteID = GetWaterSourceSpriteID(mapWaterSource[i].spriteX, mapWaterSource[i].spriteY)
    next

    rem lead in water target count into memory
    rem redim array
    map.arrayWaterGoalCount = val(readline(MapFileID))
    dim mapWaterGoal[map.arrayWaterGoalCount + 1] as TYPE_WATER_GOAL

    rem now read in values for the water sources
    for i = 0 to map.arrayWaterGoalCount
        tempString = readline(MapFileID)

        mapWaterGoal[i].X = val(SplitString(tempString,",",0))
        mapWaterGoal[i].Y = val(SplitString(tempString,",",1))
        mapWaterGoal[i].direction = val(SplitString(tempString,",",2))

        mapWaterGoal[i].spriteX = mapWaterGoal[i].X * 2
        mapWaterGoal[i].spriteY = mapWaterGoal[i].Y * 2
        mapWaterGoal[i].spriteID = GetWaterGoalSpriteID(mapWaterGoal[i].spriteX, mapWaterGoal[i].spriteY, mapWaterGoal[i].direction)
    next

    rem read width and height string in
    tempString = readline(MapFileID)

    rem split the string
    map.mapWidth = val(SplitString(tempString,",",0))
    map.mapHeight = val(SplitString(tempString,",",1))

    rem set values so we can try to efficiently loop through the map
    map.newMinX = 0
    map.newMinY = 0
    map.newMaxX = map.mapWidth - 1
    map.newMaxY = map.mapHeight - 1

    rem set values so we can determine which offset the player can have (if any)
    map.maxOffsetX = map.mapWidth - 160
    map.maxOffsetY = map.mapHeight - 160
    rem redim map data array since we now have width and height
    dim mapPixelData[map.mapWidth, map.mapHeight]

    rem parse the RLE file and set data to the fields
    while fileEOF(MapFileID) = 0
        tempString = readline(MapFileID)
        if tempString = ""
            exit
        endif

        tempType = SplitString(tempString,",",0)
        tempCount = val(SplitString(tempString,",",1))


        for i = 0 to tempCount - 1
            tempTypeValue = -1

            if tempType = "T"
                tempTypeValue = 0
            else
                tempTypeValue = 1
            endif

            mapPixelData[x,y] = tempTypeValue

            x = x + 1
                if x = map.mapWidth
                    x = 0
                    y = y +1
                endif
        next
    endwhile

    closefile(MapFileID)

    insertGoalData(tempReplaceData)
    UpdateGameplayGUI(0,0,0)
    rem get level rank scores in
    levelRankScores[0] = levelList[levelSelected].rS
    levelRankScores[1] = levelList[levelSelected].rA
    levelRankScores[2] = levelList[levelSelected].rB
    levelRankScores[3] = levelList[levelSelected].rC
    levelRankScores[4] = levelList[levelSelected].rD
    levelRankScores[5] = levelList[levelSelected].rE

    rem play new music
    playMediaMusicLevel()

endfunction

function insertGoalData(pReplaceData as integer)
    i as integer
    j as integer
    k as integer

    for i = 0 to map.arrayWaterGoalCount
        rem downwards
        if mapWaterGoal[i].direction = 0
            for j = 0 to 7
                for k = 0 to 7
                    if k = 7
                        mapPixelData[mapWaterGoal[i].X + j, mapWaterGoal[i].Y + k] = 3
                    else
                        if pReplaceData = 1
                            mapPixelData[mapWaterGoal[i].X + j, mapWaterGoal[i].Y + k] = 0
                        endif
                    endif
                next
            next
        elseif mapWaterGoal[i].direction = 1
             rem left
            for j = 0 to 7
                for k = 0 to 7
                    if k = 0
                        mapPixelData[mapWaterGoal[i].X + k, mapWaterGoal[i].Y + j] = 3
                    else
                        if pReplaceData = 1
                            mapPixelData[mapWaterGoal[i].X + k, mapWaterGoal[i].Y + j] = 0
                        endif
                    endif
                next
            next
        else
            rem right
            for j = 0 to 7
                for k = 0 to 7
                    if k = 7
                        mapPixelData[mapWaterGoal[i].X + k, mapWaterGoal[i].Y + j] = 3
                    else
                        if pReplaceData = 1
                            mapPixelData[mapWaterGoal[i].X + k, mapWaterGoal[i].Y + j] = 0
                        endif
                    endif
                next
            next
        endif
    next
endfunction
