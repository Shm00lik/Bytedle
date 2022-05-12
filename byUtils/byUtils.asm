; STACK
;  miliseconds
;  ^^^^^^^^^^^
; SP is now here
proc sleep_ms
    push bp
    mov bp, sp

    MILISECONDS equ [bp + 4]

    push ax
    push bx
    push cx
    push dx

    xor cx, cx
    xor dx, dx

    mov bx, MILISECONDS
    mov ax, 1000
    
    mul bx

    cmp dx, 0
    jl @@continue

    mov cx, dx

    @@continue:
    mov dx, cx
    
    mov ax, 8600h
    int 15h

    pop dx
    pop cx
    pop bx
    pop ax

    pop bp
    ret 2
endp sleep_ms

macro sleepMS miliseconds
    push miliseconds
    call sleep_ms
endm sleepMS

;========================================================
;========================================================
;========================================================

proc createFlagFile
    push ax
    push bx
    push cx
    push dx

    xor ax, ax
    mov ah, 3ch
    mov cx, 00h ; read only
    mov dx, offset RAND_WORD_FLAG_PATH

    int 21h

    mov bx, ax
    xor ax, ax
    mov ah, 3eh

    int 21h

    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp createFlagFile

;========================================================
;========================================================
;========================================================

proc readRandomWord
    push ax
    push bx
    push cx
    push dx

    xor ax, ax

    ; Opening the file:
    mov ah, 3Dh
    mov dx, offset RAND_WORD_PATH
    int 21h
    mov bx, ax

    ; Reading the file:
    xor ax, ax
    mov ah, 3fh
    mov cx, 05h ; 1 byte per 1 letter
    mov dx, offset correctWord
    int 21h

    ; Closing the file:
    xor ax, ax
    mov ah, 3eh
    int 21h


    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp readRandomWord

;========================================================
;========================================================
;========================================================

proc generateRandomWord
    call createFlagFile
    call readRandomWord
    ret
endp generateRandomWord
