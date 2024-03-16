type TYPE_HIGHSCORES
    score as integer
    rank as string
ENDTYPE

global dim highscoreList[1] as TYPE_HIGHSCORES
global highScoreCount as integer
global highestAvailableLevel as integer
global highestCompletedLevel as integer
global shownCompletedAllLevels as integer
global shownCompletedAllSRank as integer

function initHighScoreList(pLevelCount as integer)
    i as integer
    highScoreCount = pLevelCount

    dim highScoreList[highScoreCount] as TYPE_HIGHSCORES

    for i = 0 to highScoreCount
        highScoreList[i].score = 0
        highScoreList[i].rank = "-"
    next
loadHighScores()
endfunction

function loadHighScores()
    tLevelID as integer
    tString as string

     highestAvailableLevel = 0
     highestCompletedLevel = 0
     shownCompletedAllLevels = 0
     shownCompletedAllSRank = 0

    if GameFull = 1
            if GetFileExists("highscores.csv") = 1

                rem open file
                opentoread(ScoresFileID, "highscores.csv")

                rem read in file version to make sure that
                rem we have the right data saved
                tString = readline(ScoresFileID)

                rem read in file version time
                if tString = "V1"
                    rem read level unlock data in
                    tString = readline(ScoresFileID)
                    highestAvailableLevel = val(tString)
                    tString = readline(ScoresFileID)
                    highestCompletedLevel = val(tString)


                    tString = readline(ScoresFileID)
                    shownCompletedAllLevels = val(tString)
                     tString = readline(ScoresFileID)
                    shownCompletedAllSRank = val(tString)
                        rem read til out of info in file
                        while fileEOF(ScoresFileID) = 0
                            rem read in line
                            tString = readline(ScoresFileID)
                            rem skip last line if it is empty space
                            if tString <> ""
                                highScoreList[tLevelID].score = val(SplitString(tString, ",", 0))
                                highScoreList[tLevelID].rank = SplitString(tString, ",", 1)

                                tLevelID = tLevelID + 1
                            endif
                        endwhile

                    rem this code allows levels to be added
                    rem even if the user completed them all
                    if highestCompletedLevel = highestAvailableLevel
                        if highestAvailableLevel < levelListCount
                            shownCompletedAllLevels = 0
                            shownCompletedAllSRank = 0
                            highestAvailableLevel = highestAvailableLevel + 1
                        endif
                    endif
                endif

                closefile(ScoresFileID)
            endif

    endif

    levelSelectOffset = floor(highestAvailableLevel / 6)
endfunction

function saveHighScores()
    i as integer

        if highestAvailableLevel > levelListCount
            highestAvailableLevel = levelListCount
        endif

    if GameFull = 1
            deletefile("highscores.csv")
            opentowrite(ScoresFileID, "highscores.csv", 0)
                rem write down the version of the app
                rem in the first line
                writeline(ScoresFileID, GameVersion)
                writeline(ScoresFileID, str(highestAvailableLevel))
                writeline(ScoresFileID, str(highestCompletedLevel))
                writeline(ScoresFileID, str(shownCompletedAllLevels))
                writeline(ScoresFileID, str(shownCompletedAllSRank))

                for i = 0 to highScoreCount
                    writeline(ScoresFileID, str(highScoreList[i].score) + "," + highScoreList[i].rank)
                next
            closefile(ScoresFileID)

    endif

endfunction

function resetHighScores()
    rem
    rem comment this back in to redo high scores
    DeleteFile("highscores.csv")
    initHighScoreList(highScoreCount)
endfunction

rem return 1 if new high score
rem return 0 if not
function updateHighScore(pIndex as integer, pScore as integer, pRank as string)
    myReturn as integer

    if highScoreList[pIndex].score < pScore
        myReturn = 1
        highScoreList[pIndex].score = pScore
        highScoreList[pIndex].rank = pRank

    endif

    if highestCompletedLevel < pIndex
        highestCompletedLevel = pIndex
    endif

    if (pIndex + 1) > highestAvailableLevel
        highestAvailableLevel = (pIndex + 1)

        if highestAvailableLevel > levelListCount
            highestAvailableLevel = levelListCount
        endif
    endif

    rem save high score list
    saveHighScores()
endfunction myReturn

function getHighScoreRank(pIndex as integer)
    myReturn as string
    myReturn = highScoreList[pIndex].rank
endfunction myReturn

function getHighScore(pIndex as integer)
    myReturn as integer
    myReturn = highScoreList[pIndex].score
endfunction myReturn

function CanShowFinishAllLevels()
    myReturn as integer
    myReturn = 1

    if GameFull = 1
        if shownCompletedAllLevels = 1
            myReturn = 0
        endif
    endif

    if highestCompletedLevel < highScoreCount
        myReturn = 0
    endif
endfunction myReturn

function CanShowFinishAllSRank()
    myReturn as integer
    myReturn = 1

    if GameFull = 1
        if shownCompletedAllSRank = 1
            myReturn = 0
        endif
    endif

    if GotAllSRank() = 0
        myReturn = 0
    endif

endfunction myReturn

function GotAllSRank()
    myReturn as integer
    myReturn = 1

    for i = 0 to highScoreCount
        if highScoreList[i].rank <> "S"
            myReturn = 0
        endif
    next

endfunction myReturn
