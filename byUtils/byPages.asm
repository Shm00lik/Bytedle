; STACK:
; screen path offset
; show mouse
; ^^^^^^^^^^^^^
; SP is now here
proc showScreen
    push bp
    mov bp, sp

    SCREEN_PATH_OFFSET equ [bp + 6]
    SHOW_MOUSE         equ [bp + 4]

    ; call clearScreen
	; deactivateMouseAndSavePosition

	push bx

    mov bx, SHOW_MOUSE
    cmp bx, 00000001h
    je @@activateMouse

    jmp @@deactivateMouse

    @@activateMouse:
    call activateMouse
    jmp @@continue

    @@deactivateMouse:
    call deactivateMouse
    jmp @@continue

    @@continue:
    pop bx
    
    push dx
    
	mov dx, SCREEN_PATH_OFFSET
	mov [BmpLeft], 0
	mov [BmpTop], 0
	mov [BmpColSize], 320
	mov [BmpRowSize], 200
	
	call OpenShowBmp

   	pop dx

    mov [stopScreen], 1

    pop bp
	ret 4
endp showScreen

;========================================================
;========================================================
;========================================================

proc menuScreen
    push ax
    push bx

    mov al, [currentScreen]
    add al, "0"
    mov bx, offset MENU_IMAGE
    add bx, 22
    mov [bx], al

    push offset MENU_IMAGE
    push 1
    call showScreen

    pop bx
    pop ax
    ret
endp menuScreen

;========================================================
;========================================================
;========================================================

proc gameScreen
    deactivateMouseAndSavePosition
    call setupGameScreen
    call playGame
    ret
endp gameScreen

;========================================================
;========================================================
;========================================================

proc loseScreen
    sleepMS 1000

    push offset LOSS_IMAGE
    push 0
    call showScreen
	
    
    push DELAY_BETWEEN_LETTERS
	push offset correctWordWithColors
	push 3
	call displayWord

    sleepMS 5000

    mov ax, 4C00h ; returns control to dos
  	int 21h

    ret
endp loseScreen

;========================================================
;========================================================
;========================================================

proc winScreen
    push offset WIN_IMAGE
    push 1
    call showScreen

    sleepMS 3000
    
    mov ax, 4C00h ; returns control to dos
  	int 21h
    ret
endp winScreen

;========================================================
;========================================================
;========================================================

proc learnScreen
    push offset LEARN_IMAGE
    push 1
    call showScreen
    ret
endp learnScreen

;========================================================
;========================================================
;========================================================

proc learnBackScreen
    push offset LEARN_BACK_IMAGE
    push 1
    call showScreen
    ret
endp learnBackScreen

;========================================================
;========================================================
;========================================================

proc quitScreen
    push offset QUIT_IMAGE
    push 0
    call showScreen

    sleepMS 1000

    mov ax, 4C00h ; returns control to dos
  	int 21h
    ret
endp quitScreen
