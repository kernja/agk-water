rem load all level information into memory
type TYPE_LEVEL_LIST
    levelID as integer
    levelPath as string
    levelName as string
    levelImage as string
    rS as integer
    rA as integer
    rB as integer
    rC as integer
    rD as integer
    rE as integer
endtype

global dim levelList[1] as TYPE_LEVEL_LIST
global levelListCount as integer
global levelSelected as integer

function LoadLevelList()
    tString as string
    rem do this so we can correctly dim the level list array later
    levelListCount = -1
    rem set first level to be selected
    levelSelected = 0

 opentoread(LevelFileID, "levelList.csv")
        rem skip first line
        rem header file
        readline(LevelFileID)
        rem read til out of info in file
        while fileEOF(LevelFileID) = 0
            rem read in line
            tString = readline(LevelFileID)

            rem skip last line if it is empty space
            if tString <> ""
                rem increment variable and redim array
                levelListCount = levelListCount + 1
                dim levelList[levelListCount + 1] as TYPE_LEVEL_LIST

                levelList[levelListCount].levelID = val(SplitString(tString, ",", 0))
                levelList[levelListCount].levelPath = SplitString(tString, ",", 1)
                levelList[levelListCount].levelImage = SplitString(tString, ",", 2)
                levelList[levelListCount].levelName = SplitString(tString, ",", 3)
                levelList[levelListCount].rS = val(SplitString(tString, ",", 4))
                levelList[levelListCount].rA = val(SplitString(tString, ",", 5))
                levelList[levelListCount].rB = val(SplitString(tString, ",", 6))
                levelList[levelListCount].rC = val(SplitString(tString, ",", 7))
                levelList[levelListCount].rD = val(SplitString(tString, ",", 8))
                levelList[levelListCount].rE = val(SplitString(tString, ",", 9))
            endif
        endwhile

    closefile(LevelFileID)

    initHighScoreList(levelListCount)
endfunction
