function loadUserPreferences()
    tString as string

    if GetFileExists("userpref.txt") = 1
        rem open file
         opentoread(UserPrefID, "userpref.txt")

            tString = readline(UserPrefID)
            if tString = "V1"
                rem read in line
                rem first line is sound effects
                tString = readline(UserPrefID)
                setMediaFXPlayback(val(tString))
                 rem second line is music
               tString = readline(UserPrefID)
                setMediaMusicPlayback(val(tString))
            endif
        closefile(UserPrefID)

    else
        setMediaFXPlayback(1)
        setMediaMusicPlayback(0)
        saveUserPreferences()
    endif

endfunction

function saveUserPreferences()
    i as integer

    deletefile("userpref.txt")
    opentowrite(UserPrefID, "userpref.txt", 0)
        `for i = 0 to highScoreCount
        `    writeline(UserPrefID, str(highScoreList[i].score) + "," + highScoreList[i].rank)
        `next
        writeline(UserPrefID, GameVersion)
        writeline(UserPrefID, str(GetCanPlayMediaFX()))
        writeline(UserPrefID, str(GetCanPlayMediaMusic()))
    closefile(UserPrefID)

endfunction
