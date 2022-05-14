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

;========================================================
;========================================================
;========================================================

proc activateMouse
	push ax
    
	mov ax, 0h
	int 33h

	mov ax, 1h
	int 33h

	pop ax
	ret
endp activateMouse

;========================================================
;========================================================
;========================================================

proc deactivateMouse
	push ax

	mov ax, 2h
	int 33h

	pop ax
	ret
endp deactivateMouse

;========================================================
;========================================================
;========================================================

proc saveCursorPosition
    push cx
    push dx

    call checkMouseLocation
    mov [offset lastCursorX], cx
    mov [offset lastCursorY], dx

    pop dx
    pop cx
    ret
endp saveCursorPosition

;========================================================
;========================================================
;========================================================

proc setCursorPosition
    push ax
    push bx
    push cx
    push dx
    
    xor ax, ax

    mov ah, 04h
    mov cx, [offset lastCursorX]
    mov dx, [offset lastCursorY]
    int 33h

    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp setCursorPosition

;========================================================
;========================================================
;========================================================

; CX, DX -> X, Y
; BX -> buttons
proc checkMouseLocation
    push ax
    mov ax, 3h
    int 33h

    shr cx, 1

    pop ax
    ret
endp checkMouseLocation

;========================================================
;========================================================
;========================================================

proc setDesiredPage
    push ax
    push bx
    push cx
    push dx

    cmp [currentScreen], 4
    je @@exit

    call checkMouseLocation

    cmp [currentScreen], 4
    jl @@menuButtons

    cmp [currentScreen], 7
    je @@learnButtons

    cmp [currentScreen], 8
    je @@learnButtons

    jmp @@exit
    
    @@menuButtons:
    call checkForMenuButtonHover
    jmp @@end

    @@learnButtons:
    call checkForLearnButtonHover
    jmp @@end
    
    @@end:
    call handleMouseClick
    cmp al, [currentScreen]
    je @@exit


    mov [currentScreen], al
    mov [stopScreen], 0


    @@exit:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp setDesiredPage

;========================================================
;========================================================
;========================================================

proc checkForMenuButtonHover
    cmp cx, 100
    jl @@mainMenu

    cmp cx, 219
    jg @@mainMenu

    cmp dx, 97
    jl @@mainMenu

    cmp dx, 120
    jl @@playButton

    cmp dx, 126
    jl @@mainMenu

    cmp dx, 149
    jl @@learnButton

    cmp dx, 155
    jl @@mainMenu

    cmp dx, 178
    jl @@quitButton

    jmp @@mainMenu

    @@playButton:
    mov ax, 1
    jmp @@end

    @@learnButton:
    mov ax, 2
    jmp @@end

    @@quitButton:
    mov ax, 3
    jmp @@end

    @@mainMenu:
    mov ax, 0
    jmp @@end
    
    @@end:
    ret
endp checkForMenuButtonHover

;========================================================
;========================================================
;========================================================

proc checkForLearnButtonHover
    cmp cx, 4
    jl @@learnScreen

    cmp cx, 52
    jg @@learnScreen

    cmp dx, 175
    jl @@learnScreen

    cmp dx, 200
    jl @@backButton

    jmp @@learnScreen

    @@backButton:
    mov ax, 8
    jmp @@end

    @@learnScreen:
    mov ax, 7
    jmp @@end

    @@end:
    ret
endp checkForLearnButtonHover

;========================================================
;========================================================
;========================================================

proc handleMouseClick
    shr bx, 1
    jnc @@exit
    
    cmp [currentScreen], 0
    je @@exit

    cmp [currentScreen], 1
    je @@gameScreen

    cmp [currentScreen], 2
    je @@learnScreen

    cmp [currentScreen], 3
    je @@quitScreen

    cmp [currentScreen], 8
    je @@menuScreen

    jmp @@exit

    @@menuScreen:
    mov ax, 0
    jmp @@exit

    @@gameScreen:
    mov ax, 4
    jmp @@exit

    @@learnScreen:
    mov ax, 7
    jmp @@exit

    @@quitScreen:
    mov ax, 9
    jmp @@exit

    @@exit:
    ret
endp handleMouseClick