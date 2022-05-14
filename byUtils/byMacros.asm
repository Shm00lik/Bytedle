macro resetTimer timer
    mov ah, 0
    int 1Ah
    mov [offset timer], dx
endm

;========================================================
;========================================================
;========================================================

macro checkTimer timer, ticks, callback

    mov ah, 0
    int 1Ah

    sub dx, [offset timer]
    cmp dx, ticks

    jge @@set_carry
    jmp @@endmac

    @@set_carry:
    resetTimer timer
    call callback

    @@endmac:
endm

;========================================================
;========================================================
;========================================================

macro sleepMS miliseconds
    push miliseconds
    call sleep_ms
endm

;========================================================
;========================================================
;========================================================

macro activateMouseToLastPosition
    call activateMouse
    call setCursorPosition
endm

;========================================================
;========================================================
;========================================================

macro deactivateMouseAndSavePosition
    call saveCursorPosition
    call deactivateMouse
endm