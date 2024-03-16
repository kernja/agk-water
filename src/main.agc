#include "SplitString.agc"
#include "LoadImagesFromList.agc"
#include "spriteFactory.agc"
#include "Gameplay.agc"
#include "LoadMap.agc"
#include "gui.agc"
#include "LoadLevelsIndex.agc"
#include "touchInput.agc"
#include "menuSystem.agc"
#include "mediaPlayer.agc"
#include "highScores.agc"
#include "userPreferences.agc"
rem CONSTANTS ----------------------
#constant ImageFileID 1
#constant MapFileID 2
#constant LevelFileID 3
#constant ScoresFileID 4
#constant UserPrefID 4
#constant SpriteMap 499
#constant ImageMap 10
#constant guiGameplay 400
#constant SpriteTargetingArrow 498
#constant GameVersion "V1"
#constant GameFull 1
rem load user preferences into memory
loadUserPreferences()
rem load all levels into memory
LoadLevelList()

rem create data for holding level rank
rem this is best achieved by just holding an integer array
rem and going through each one
global dim levelRankScores[6] as integer
global dim mapRowCheck[320] as integer
global dim newRowCheck[320] as integer
rem SET UP RESOLUTION --------------
SetVirtualResolution(480,320)
SetOrientationAllowed(0,0,1,1)
SetTransitionMode(1)
SetResolutionMode(0)
`SetSortTextures(1)
rem SET UP DEFAULTS
SetDefaultMagFilter(0)
SetDefaultMinFilter(0)
SetTextDefaultMagFilter(1)
SetTextDefaultMinFilter(1)
rem LOAD MEDIA ---------------------
LoadImageDataFromFile()
CreateWaterDropletSprites()

rem load sfx
LoadSound(1, "sfx/destroy.wav")
LoadSound(2, "sfx/error.wav")
LoadSound(3, "sfx/beep.wav")
LoadSound(4, "sfx/shuffle.wav")
LoadMusic(1, "sfx/bg_lq.mp3")
LoadMusic(2, "sfx/bg2_lq.mp3")
LoadMusic(3, "sfx/bg3_lq.mp3")
LoadMusic(4, "sfx/70s_lq.mp3")
LoadMusic(5, "sfx/bigbeat_lq.mp3")
LoadMusic(6, "sfx/brazil_lq.mp3")
LoadMusic(8, "sfx/water.mp3")
rem create targeting sprite
CreateSprite(SpriteTargetingArrow, 20)
SetSpriteOffset(SpriteTargetingArrow, 62,62)
SetSpriteVisible(SpriteTargetingArrow, 0)
rem CREATE FONT --------------------
rem REFER TO VALUES IN EXCEL BOOK
settextdefaultfontimage(7)

rem CREATE GUI ---------------------
createGameplayGUI()

rem A Wizard Did It!

type TYPE_WATER_DROPLET
    X as integer
    Y as integer
    active as integer
    id as integer
endtype

global dim mapWaterDroplets[1999] as TYPE_WATER_DROPLET

`LoadMapFromFile()
`ShowDefaultGameplayGUI()
PlayMediaMusic(1,1)

createMainMenuGUI()
SetMainMenuVisible(1)

rem this is required so that
rem android users can press back and exit the app
If getrawkeypressed(27)
    end
endif

`highestAvailableLevel = 216
do
    `for i = 0 to map.mapMadeDroplets - 1
    `    print(str(mapWaterDroplets[i].X) + "," + str(mapWaterDroplets[i].Y) + "," + str(mapWaterDroplets[i].active) + ","  + str(mapWaterDroplets[i].id))
    `next i
    `print(GetTimeElapsed())
    updateTouchInput()
`    print(GetPointerState())
    `updaterotation()
    if menuState = 0
        updateMainMenuGUI(touchInput.X, touchInput.Y)
    elseif menuState = 1
        updateTutorialGUI(touchInput.X, touchInput.Y)
    elseif menuState = 2
        updateAboutGUI(touchInput.X, touchInput.Y)
    elseif menuState = 3
        updateOptionsGUI(touchInput.X, touchInput.Y)
    elseif menuState = 4
        updateLevelSelectScrollGUI(touchInput.X, touchInput.Y)
    elseif menuState = 5
        updateLevelPreviewGUI(touchInput.X, touchInput.Y)
    elseif menuState = 6
        GameplayLoop(touchInput.X, touchInput.Y)
    elseif menuState = 7
        updateCongratsGUI(touchInput.X, touchInput.Y)
    endif
    `
    Sync()
loop
