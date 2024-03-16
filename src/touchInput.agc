type TYPE_TOUCH_INPUT
    X as integer
    Y as integer

    touchCount as integer
    touchReleased as integer
    touchBomb as integer

    X1 as integer
    X2 as integer
    Y1 as integer
    Y2 as integer

endtype

global touchInput as TYPE_TOUCH_INPUT

function updateTouchInput()
    tX as float
    tY as float
    tIndex as integer

    touchInput.touchCount = 0
    touchInput.touchReleased = 0

    if GetMultiTouchExists() = 1
        tIndex = GetRawFirstTouchEvent(1)

        while tIndex <> 0
            tX = tX + GetRawTouchCurrentX(tIndex)
            tY = tY + GetRawTouchCurrentY(tIndex)
            touchInput.touchCount = touchInput.touchCount + 1
            touchInput.touchReleased = touchInput.touchReleased + GetRawTouchReleased(tIndex)
            tIndex = GetRawNextTouchEvent()
        endwhile

        if touchInput.touchCount <> 0
            touchInput.X = tX / touchInput.touchCount
            touchInput.Y = tY / touchInput.touchCount
        endif
    else
        touchInput.X = GetPointerX()
        touchInput.Y = GetPointerY()
    endif
endfunction
