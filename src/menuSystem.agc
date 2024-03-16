global menuState as integer
global tutorialProgress as integer
global aboutProgress as integer

global levelSelectOffset as integer
global levelSelectOffsetMax as integer
global levelSelectSpriteCount as integer
global levelSelectBase as integer

global levelSelectScrollX1 as integer
global levelSelectScrollX2 as integer
global levelSelectScrollDiff as integer

global levelPreviewSpriteRotation as float

global congratsBGIndex as float

function createMainMenuGUI()
    i as integer
    rem this is background image
    createSprite(200, 23)

    rem create background image for tutorial
    createSprite(201, 25)
    SetSpriteVisible(201, 0)

    rem create image for about
    createSprite(202, 42)
    SetSpriteVisible(202, 0)

    rem create image for options
    createSprite(203, 34)
    SetSpriteVisible(203, 0)

    rem create image for level select
    createSprite(204, 35)
    SetSpriteVisible(204, 0)

    rem create level preview sprite
    rem this is 205
    createSprite(205, 10)
    SetSpriteVisible(205, 0)
    SetSpriteSize(205, .5, .5)
    SetSpriteOffset(205, GetImageWidth(10) * .5, GetImageHeight(10) * .5)
    SetSpritePositionByOffset(205, 354,176)


    rem create image for congrats bg
    createSprite(206, 40)
    SetSpriteVisible(206, 0)
    SetSpriteDepth(206, 11)
    SetSpriteSize(206, 480, 320)

    rem create image for congrats finish all text
    createSprite(207, 41)
    SetSpriteVisible(207, 0)
    setspritedepth(207, 9)
     rem create image for congrats finish s rank text
    `createSprite(208, )
    `SetSpriteVisible(208, 0)
    `setspritedepth(208, 9)
    rem create sprites for the scroll thing
    rem at the bottom of the screen
    tLevelInt as integer
    tLevelMod as float
    tSpriteCount as integer

    tLevelInt = (levelListCount + 1) / 6
    tLevelMod =  fmod((levelListCount + 1), 6)

    if tLevelMod > 0
        tSpriteCount = tLevelInt + 1
    else
        tSpriteCount = tLevelInt
    endif
    rem store total amounts of sprites made
    levelSelectSpriteCount = tSpriteCount
    rem level select max offset is ironically this number too
    levelSelectOffsetMax = levelSelectSpriteCount - 1
    rem center of width is 240
    rem multiply width of icons plus pixel offset (10) by total icons
    rem divide in half
    tIconWidth as integer
    tIconWidth = (tSpriteCount * 10) * .5

    for i = 210 to (210 + levelSelectSpriteCount - 1)
        createSprite(i, 37)
        SetSpriteOffset(i, 4, 4)
        SetSpriteVisible(i, 0)
        `SetSpritePosition(i, 0, 0)
        `SetSpritePosition(i, 240 - tIconWidth  + ((i-210) * 10), 275)
        `SetSpritePositionByOffset(i, 0, 0)
        SetSpritePositionByOffset(i, 240 - tIconWidth  + ((i-210) * 10), 255)
        SetSpriteDepth(i, 9)
    next i

    rem create level text
    createText(200, "LEVEL SELECT")
    SetTextFontImage(200, 24)
    SetTextPosition(200, 48, 86)
    SetTextSize(200,34)
    SetTextSpacing(200,-6)

    createText(201, "HOW TO PLAY")
    SetTextFontImage(201, 24)
    SetTextPosition(201, 48, 126)
    SetTextSize(201,34)
    SetTextSpacing(201,-6)

    createText(202, "OPTIONS")
    SetTextFontImage(202, 24)
    SetTextPosition(202, 48, 166)
    SetTextSize(202,34)
    SetTextSpacing(202,-6)

    createText(203, "ABOUT")
    SetTextFontImage(203, 24)
    SetTextPosition(203, 48, 206)
    SetTextSize(203,34)
    SetTextSpacing(203,-6)


    rem create options text
    rem the gap is in case we need to make more menu options later
    createText(210, "TOGGLE FX")
    SetTextFontImage(210, 24)
    SetTextPosition(210, 48, 86)
    SetTextSize(210,34)
    SetTextSpacing(210,-6)
    SetTextVisible(210, 0)

    createText(211, "Sound effects will be played")
    SetTextFontImage(211, 24)
    SetTextPosition(211, 64, 110)
    SetTextSize(211,26)
    SetTextSpacing(211,-6)
    SetTextVisible(211, 0)

    createText(212, "TOGGLE MUSIC")
    SetTextFontImage(212, 24)
    SetTextPosition(212, 48, 139)
    SetTextSize(212,34)
    SetTextSpacing(212,-6)
    SetTextVisible(212, 0)

    createText(213, "Game music will be played")
    SetTextFontImage(213, 24)
    SetTextPosition(213, 64, 163)
    SetTextSize(213,26)
    SetTextSpacing(213,-6)
    SetTextVisible(213, 0)

    createText(214, "ERASE ALL HIGH SCORES")
    SetTextFontImage(214, 24)
    SetTextPosition(214, 48, 192)
    SetTextSize(214,34)
    SetTextSpacing(214,-6)
    SetTextVisible(214, 0)

    createText(215, "All high scores have been erased")
    SetTextFontImage(215, 24)
    SetTextPosition(215, 64, 216)
    SetTextSize(215,26)
    SetTextSpacing(215,-6)
    SetTextVisible(215, 0)

    createText(216, "DONE WITH OPTIONS")
    SetTextFontImage(216, 24)
    SetTextSize(216,34)
    SetTextSpacing(216,-6)
    SetTextPosition(216, 480 - GetTextTotalWidth(216) - 5, 320 - GetTextTotalHeight(216))
    SetTextVisible(216, 0)

    rem create level select text
    rem the gap is in case we need to make more menu options later
    for i = 0 to 6
        createText(230 + i, "LEVEL " + str(tSpriteCount))
        SetTextFontImage(230 + i, 24)
        SetTextPosition(230+ i, 24, 66 + (i * 30))
        SetTextSize(230+i,34)
        SetTextSpacing(230+i,-6)
        SetTextVisible(230+i, 0)
    next i

    createText(237, "BACK TO MAIN MENU")
    SetTextFontImage(237, 24)
    SetTextSize(237,34)
    SetTextSpacing(237,-6)
    SetTextPosition(237, 480 - GetTextTotalWidth(237) - 5, 320 - GetTextTotalHeight(237))
    SetTextVisible(237, 0)

    rem level preview text
    rem create level select text
    createText(240, "LEVEL")
    SetTextFontImage(240, 24)
    SetTextPosition(240, 48, 66)
    SetTextSize(240,34)
    SetTextSpacing(240,-6)
    SetTextVisible(240, 0)
    settextdepth(240, 8)
    createText(241, "HIGH SCORE:")
    SetTextFontImage(241, 7)
    SetTextPosition(241, 48, 106)
    SetTextSize(241,29)
    SetTextSpacing(241,-6)
    SetTextVisible(241, 0)

    createText(242, "12345678")
    SetTextFontImage(242, 7)
    SetTextPosition(242, 48, 124)
    SetTextSize(242,29)
    SetTextSpacing(242,-6)
    SetTextVisible(242, 0)

    createText(243, "RANKING: S")
    SetTextFontImage(243, 7)
    SetTextPosition(243, 48, 160)
    SetTextSize(243,29)
    SetTextSpacing(243,-6)
    SetTextVisible(243, 0)

    createText(244, "SELECT NEW")
    SetTextFontImage(244, 24)
    SetTextSize(244,34)
    SetTextSpacing(244,-6)
    SetTextPosition(244, 5, 320 - GetTextTotalHeight(244))
    SetTextVisible(244, 0)

    createText(245, "PLAY LEVEL")
    SetTextDepth(245, 8)
    SetTextFontImage(245, 24)
    SetTextSize(245,34)
    SetTextSpacing(245,-6)
    SetTextPosition(245, 480 - GetTextTotalWidth(245) - 5, 320 - GetTextTotalHeight(245))
    SetTextVisible(245, 0)

    setMainMenuVisible(0)
endfunction

function setMainMenuVisible(pVisible as integer)
    i as integer

    SetSpriteVisible(200, pVisible)

    for i = 200 to 203
        SetTextVisible(i, pVisible)
    next i
endfunction

function setOptionsMenuVisible(pVisible as integer)
    i as integer

    SetSpriteVisible(203, pVisible)

    for i = 210 to 214
        SetTextVisible(i, pVisible)
    next i

    if pVisible = 1
        if GetCanPlayMediaFX() = 0
            SetTextString(211, "Sound effects will NOT be played")
        else
            SetTextString(211, "Sound effects will be played")
        endif

        if GetCanPlayMediaMusic() = 0
            SetTextString(213, "Game music will NOT be played")
        else
            SetTextString(213, "Game music will be played")
        endif

    endif
    rem we always hide this text, it only appears after the user clears
    rem the high score memory
    setTextVisible(215, 0)

    setTextVisible(216, pVisible)
endfunction

function updateLevelSelectScrollLevels()
    i as integer
    tLevelMax as integer
    tLevelBase as integer
    tTextIndex as integer
    rem hide all levels
    rem we will make 'em visible again
    rem when we update the level text
    for i = 230 to 235
        SetTextVisible(i, 0)
    next i

    rem figure out which base number we should be starting with
    tLevelBase = levelSelectOffset * 6
    levelSelectBase = tLevelBase
    rem add five, since we can have up to 6 levels in a screen including root base number
    tLevelMax = tLevelBase + 5

    if tLevelMax > levelListCount
        tLevelMax = levelListCount
    endif

    rem update level text based upon current offset
    tTextIndex = 230

    for i = tLevelBase to tLevelMax
        SetTextVisible(tTextIndex, 1)

        if highestAvailableLevel >= i
            SetTextString(tTextIndex, str(i + 1) + "- " + levelList[i].levelName)
        else
            SetTextString(tTextIndex, str(i + 1) + "- LEVEL LOCKED")
        endif

        tTextIndex = tTextIndex + 1
    next i

    rem now we update the sprites
    rem so the selected offset sprite is yellow
    for i = 210 to (210 + levelSelectSpriteCount - 1)
        SetSpriteImage(i, 37)
    next i
        SetSpriteImage(210 + levelSelectOffset, 36)
endfunction

function setLevelSelectScrollVisible(pVisible as integer)
    i as integer

    rem bg image
    setspritevisible(204, pVisible)
    rem toggle text
    for i = 230 to 237
        settextvisible(i, pVisible)
    next
    rem hide last row of text for level select
    settextvisible(236, 0)
    if pVisible = 1
        updateLevelSelectScrollLevels()
    endif

    rem scroll icons
    for i = 210 to (210 + levelSelectSpriteCount - 1)
        setspritevisible(i, pVisible)
    next
endfunction

function setLevelPreviewVisible(pVisible as integer)
    i as integer

    rem bg image
    setspritevisible(204, pVisible)

    if pVisible = 1
        rem load preview image only if being shown
        deleteimage(38)
        loadimage(38, levelList[levelSelected].levelImage)
        deletesprite(205)
        createsprite(205,38)
        SetSpriteScale(205, .5, .5)
        setspriteoffset(205, GetSpriteWidth(205) * .5, GetSpriteHeight(205) * .5)
        setSpritedepth(205, 9)
        setspritepositionbyoffset(205, 324,186)
    endif

    setspritevisible(205, pVisible)
    levelPreviewSpriteRotation = 0

    settextstring(240, levelList[levelSelected].levelName)
    for i = 240 to 245
        settextvisible(i, pVisible)
    next

    rem this updates score and rank
    settextstring(242, "  " + str(getHighScore(levelSelected)))
    rem and now rank
    settextstring(243, "RANKING: " + getHighScoreRank(levelSelected))
endfunction

function updateLevelSelectScrollGUI(pPointerX as integer, pPointerY as integer)
    i as integer

    if GetPointerPressed() = 1
        levelSelectScrollX1 = pPointerX
        levelSelectScrollDiff = 0
    endif

    if GetPointerReleased() = 1
        rem figure out whether or not the person scrolled
        levelSelectScrollX2 = pPointerX
        levelSelectScrollDiff = levelSelectScrollX2 - levelSelectScrollX1

        rem greater number means scroll right
        rem which means move menu to lower-number levels
        if levelSelectScrollDiff > 60
            levelSelectOffset = levelSelectOffset - 1
                if levelSelectOffset < 0
                    levelSelectOffset = 0
                else
                    playMediaFX(4)
                endif

             updateLevelSelectScrollLevels()

        rem righer levels
        elseif levelSelectScrollDiff < -60
            levelSelectOffset = levelSelectOffset + 1
                if levelSelectOffset >     levelSelectOffsetMax
                    levelSelectOffset =     levelSelectOffsetMax
                else
                    playMediaFX(4)
                endif

             updateLevelSelectScrollLevels()
        rem check for presses
        else
            rem level select
            for i = 230 to 235
                if GetTextVisible(i) = 1
                    if CheckButtonPointerHover(i, pPointerX, pPointerY, 0,-3) = 1
                        `message(str())
                        rem user selected the level they would like to play

                        levelSelected = levelSelectBase + (i - 230)

                        rem level isn't locked
                        if highestAvailableLevel >= levelSelected
                            menuState = 5
                            setLevelSelectScrollVisible(0)
                            setLevelPreviewVisible(1)
                            playMediaFX(3)
                        else
                            playMediaFX(2)
                        endif
                    endif
                endif
            next i
            if CheckButtonPointerHover(237, pPointerX, pPointerY, 2, 2) = 1
                playMediaFX(3)
                menuState = 0
                setLevelSelectScrollVisible(0)
                SetMainMenuVisible(1)
            endif
        endif
    endif

    `if GetPointerState() = 1
        rem this is so we can still get that glow with mouseover
    if levelSelectScrollDiff <= 120 or levelSelectScrollDiff >= -120
        for i = 230 to 235
            if GetTextVisible(i) = 1
                CheckButtonPointerHover(i, pPointerX, pPointerY, 0,-3)
            endif
        next i
    endif

    CheckButtonPointerHover(237, pPointerX, pPointerY, 0,0)
endfunction

function updateLevelPreviewGUI(pPointerX as integer, pPointerY as integer)
    levelPreviewSpriteRotation = levelPreviewSpriteRotation + (GetModifiedFrameTime() * 25)

    if levelPreviewSpriteRotation > 360
        levelPreviewSpriteRotation = levelPreviewSpriteRotation - 360
    endif

    setspriteangle(205,levelPreviewSpriteRotation )

    if CheckButtonPointerHover(244, pPointerX, pPointerY, 0,0) = 1
        if GetPointerReleased() = 1
            menuState = 4
            SetLevelPreviewVisible(0)
            setLevelSelectScrollVisible(1)
            playMediaFX(3)
        endif
    endif

    if CheckButtonPointerHover(245, pPointerX, pPointerY, 0,0) = 1
        if GetPointerReleased() = 1
            menuState = 6
            SetSpriteVisible(404, 1)
            ShowDefaultGameplayGUI()
            LoadMapFromFile()
            SetLevelPreviewVisible(0)
            playMediaFX(3)
        endif
    endif


endfunction

function updateMainMenuGUI(pPointerX as integer, pPointerY as integer)
    i as integer

    rem to level select scroll
    if CheckButtonPointerHover(200, pPointerX, pPointerY, 2, 2) = 1
        if GetPointerReleased() = 1
            menuState = 4
            setMainMenuVisible(0)
            setLevelSelectScrollVisible(1)
            updateLevelSelectScrollLevels()

            `setSpriteVisible(204, 1)
            playMediaFX(3)
        endif
    endif

    rem tutorial
    if CheckButtonPointerHover(201, pPointerX, pPointerY, 2, 2) = 1
        if GetPointerReleased() = 1
            menuState = 1
            tutorialProgress = 0
            setMainMenuVisible(0)

            setSpriteImage(201, 25)
            setSpriteVisible(201, 1)
            playMediaFX(3)
        endif
    endif

    rem options
    if CheckButtonPointerHover(202, pPointerX, pPointerY, 2, 2) = 1
        if GetPointerReleased() = 1
            menuState = 3
            setMainMenuVisible(0)

            setOptionsMenuVisible(1)
            playMediaFX(3)
        endif
    endif

    rem about menu
    if CheckButtonPointerHover(203, pPointerX, pPointerY, 2, 2) = 1
        if GetPointerReleased() = 1
            menuState = 2
            tutorialProgress = 0
            setMainMenuVisible(0)

            aboutProgress = 0
            setSpriteImage(202, 42)
            setSpriteVisible(202, 1)
            playMediaFX(3)
        endif
    endif

endfunction

function updateOptionsGUI(pPointerX as integer, pPointerY as integer)
    i as integer

    rem sound effects
    if CheckButtonPointerHover(210, pPointerX, pPointerY, 2, 2) = 1
        if GetPointerReleased() = 1

            if TogglePlaybackFX() = 0
                SetTextString(211, "Sound effects will NOT be played")
            else
                SetTextString(211, "Sound effects will be played")
            endif

            playMediaFX(3)
        endif
    endif

    rem toggle music
    if CheckButtonPointerHover(212, pPointerX, pPointerY, 2, 2) = 1
        if GetPointerReleased() = 1
            playMediaFX(3)
            if TogglePlaybackMusic(1) = 0
                SetTextString(213, "Game music will NOT be played")
            else
                SetTextString(213, "Game music will be played")
            endif
        endif
    endif

    rem clear scores
    if CheckButtonPointerHover(214, pPointerX, pPointerY, 2, 2) = 1
        if GetPointerReleased() = 1
            rem erase scores
            playMediaFX(1)
            resetHighScores()
            settextvisible(215, 1)
        endif
    endif

    rem exit menu
    if CheckButtonPointerHover(216, pPointerX, pPointerY, 2, 2) = 1
        if GetPointerReleased() = 1
            playMediaFX(3)
            menuState = 0
            setOptionsMenuVisible(0)
            SetMainMenuVisible(1)

            rem save data
            saveUserPreferences()
        endif
    endif
endfunction


function updateTutorialGUI(pPointerX as integer, pPointerY as integer)
    i as integer

    if GetPointerReleased() = 1
        tutorialProgress = tutorialProgress + 1
        playMediaFX(3)

        if tutorialProgress <= 5
            setSpriteImage(201, 25 + tutorialProgress)
        else
            setSpriteVisible(201, 0)
            menuState = 0
            SetMainMenuVisible(1)
        endif
    endif
endfunction

function updateAboutGUI(pPointerX as integer, pPointerY as integer)
    i as integer

    if GetPointerReleased() = 1
        aboutProgress = aboutProgress + 1
        playMediaFX(3)

        if aboutProgress <= 7
            setSpriteImage(202, 42 + aboutProgress)
        else
            setSpriteVisible(202, 0)
            menuState = 0
            SetMainMenuVisible(1)
        endif
    endif
endfunction

function SetCongratsGUIVisible(pValue as integer, pS as integer)
    if pValue = 1
        PlayMediaMusic(8,1)

        SetSpriteVisible(206, 1)

 SetSpriteImage(207, 0)
        if pS = 0
            SetSpriteImage(207, 41)
        else
            SetSpriteImage(207, 39)
        endif

        SetSpriteVisible(207, 1)
    else
        SetSpriteVisible(206, 0)
        SetSpriteVisible(207, 0)
        `SetSpriteVisible(208, 0)

        playMediaMenu()
    endif
endfunction

function updateCongratsGUI(pPointerX as integer, pPointerY as integer)
    tIndex as float

    tIndex = congratsBGIndex
    congratsBGIndex = congratsBGIndex + (GetModifiedFrameTime() * 15)

    if congratsBGIndex >= 301
        congratsBGIndex = congratsBGIndex - 301
    endif

    if floor(tIndex) <> floor(congratsBGIndex)
        deleteimage(40)
        loadimage(40, "gui/congrats/000.jpg")
        remif congratsBGIndex >= 0 and congratsBGIndex < 10
        remloadimage(40, "gui/congrats/00" + str(floor(congratsBGIndex)) + ".jpg")
        remelseif congratsBGIndex >= 10 and congratsBGIndex < 100
        rem    loadimage(40, "gui/congrats/0" + str(floor(congratsBGIndex)) + ".jpg")
        remelse
        rem    loadimage(40, "gui/congrats/" + str(floor(congratsBGIndex)) + ".jpg")
        remendif
    endif
    SetSpriteImage(206, 40)

    if GetPointerReleased() = 1
        saveHighScores()
        SetCongratsGUIVisible(0, 0)
                    rem do normal
                    menuState = 4
                    HideGameplayGUI()
                    playMediaMenu()
                    setLevelSelectScrollVisible(1)
    endif
endfunction
