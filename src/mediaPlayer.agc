global canPlayMediaFX as integer
global canPlayMediaMusic as integer
global lastSetMusic as integer
global lastSetMusicLoop as integer

function setMediaFXPlayback(pIndex as integer)
    canPlayMediaFX = pIndex
endfunction

function setMediaMusicPlayback(pIndex as integer)
    canPlayMediaMusic = pIndex
endfunction

function playMediaFX(pIndex as integer)
    if canPlayMediaFX = 1
        playSound(pIndex)
    endif
endfunction

function playMediaMusic(pIndex as integer, pLoop as integer)
    tOldMusicID as integer

    if canPlayMediaMusic = 1
        tOldMusicID = lastSetMusic
        lastSetMusic = pIndex
        lastSetMusicLoop = pLoop

        stopMusic()
        playMusic(pIndex, pLoop, pIndex, pIndex)
    else
        lastSetMusic = pIndex
        lastSetMusicLoop = pLoop
    endif
endfunction

function playMediaMenu()
    playMediaMusic(1, 1)
endfunction

function playMediaMusicLevel()
    tMusicID as integer
    tMusicID = random(1, 6)
    playMediaMusic(tMusicID, 1)
endfunction

function GetCanPlayMediaFX()
endfunction canPlayMediaFX

function GetCanPlayMediaMusic()
endfunction canPlayMediaMusic

function TogglePlaybackFX()
    if canPlayMediaFX = 1
        canPlayMediaFX = 0
    else
        canPlayMediaFX = 1
    endif
endfunction canPlayMediaFX

function TogglePlaybackMusic(pStartPlaying as integer)
    if canPlayMediaMusic = 1
        canPlayMediaMusic = 0
        stopmusic()
    else
        canPlayMediaMusic = 1

            if pStartPlaying = 1
                playMusic(lastSetMusic, lastSetMusicLoop)
            endif
    endif
endfunction canPlayMediaMusic
