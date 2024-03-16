#constant  sfWaterSourceIndex 500
global sfWaterSourceCount as integer

#constant sfWaterGoalIndex 600
global sfWaterGoalCount as integer

#constant sfWaterDropletIndex 1000
global sfWaterDropletCount as integer

#constant sfBombIndex 700
global sfBombCount as integer

REM do water source sprites
REM call this to get assigned a new sprite id
function GetWaterSourceSpriteID(pX as integer, pY as integer)
    myReturn as integer
    myReturn = sfWaterSourceIndex + sfWaterSourceCount

    createSprite(myReturn, 2)
    SetSpriteDepth(myReturn, 12)
    SetSpritePosition(myReturn, pX + 160, pY)
    SetSpriteAnimation(myReturn, 16, 16, 3)
    PlaySprite(myReturn)

    SetSpriteVisible(myReturn, 1)
    sfWaterSourceCount = sfWaterSourceCount + 1
endfunction myReturn

function ResetWaterSourceSprites()
    i as integer
    for i = sfWaterSourceIndex to (sfWaterSourceIndex + 99)
        deletesprite(i)
    next

    sfWaterSourceCount = 0
endfunction

REM same for water goal count
REM call this to get a new sprite id
function GetWaterGoalSpriteID(pX as integer, pY as integer, pDirection as integer)
    myReturn as integer
    myReturn = sfWaterGoalIndex + sfWaterGoalCount

    createSprite(myReturn, 3 + pDirection)
    SetSpritePosition(myReturn, pX + 160, pY)
    SetSpriteDepth(myReturn, 12)
    SetSpriteAnimation(myReturn, 16, 16, 3)
    PlaySprite(myReturn)
    SetSpriteVisible(myReturn, 1)
    sfWaterGoalCount = sfWaterGoalCount + 1
endfunction myReturn

function ResetWaterGoalSprites()
    i as integer
    for i = sfWaterGoalIndex to (sfWaterGoalIndex + 99)
        deletesprite(i)
    next

    sfWaterGoalCount = 0
endfunction

REM we do things differently for the water sprites
REM we create all of them at once - hide them all
REM and set ones that we need to visible as we get them
function CreateWaterDropletSprites()
    i as integer
    for i = sfWaterDropletIndex to (sfWaterDropletIndex + 1999)
        CreateSprite(i, 1)
        SetSpriteTransparency(i, 0)
        SetSpriteVisible(i,0)
        SetSpriteDepth(i,13)
    next
endfunction

function ResetWaterDropletSprites()
    for i = sfWaterDropletIndex to (sfWaterDropletIndex + 1999)
        SetSpriteVisible(i,0)
    next

    sfWaterDropletCount = 0
endfunction

function GetWaterDropletSpriteID(pX as integer, pY as integer)
    myReturn as integer
    myReturn = sfWaterDropletIndex + sfWaterDropletCount

    sfWaterDropletCount = sfWaterDropletCount + 1

    if sfWaterDropletCount > 1999
        sfWaterDropletCount = 0
    endif

    SetSpritePosition(myReturn, (pX * 2) + 160 - map.offsetX, (pY * 2) - map.offsetY)
    SetSpriteVisible(myReturn, 1)
endfunction myReturn

REM do bomb sprites
REM call this to get assigned a new sprite id
function GetBombSpriteID(pX as integer, pY as integer)
    myReturn as integer
    myReturn = sfBombIndex + sfBombCount

    createSprite(myReturn, 9)
    SetSpriteDepth(myReturn, 14)
    SetSpriteOffset(myReturn, 10, 10)
    remstart
    `SetSpriteScale(myReturn, 1.2, 1.2)
    tX as integer
    tY as integer
    tX = pX
    tY = pY

    `SetSpritePositionByOffset(myReturn, tX + 160, tY)
    `SetSpriteVisible(myReturn, 1)

    ApplyBomb(tX, tY)
    sfBombCount = sfBombCount + 1
    map.mapDroppedBombs = map.mapDroppedBombs + 1
    remend
endfunction myReturn

function ResetBombSprites()
    i as integer
    for i = sfBombIndex to (sfBombIndex + 99)
        deletesprite(i)
    next

    sfBombCount = 0
endfunction
