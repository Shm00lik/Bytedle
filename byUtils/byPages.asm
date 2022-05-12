; STACK:
; screen path offset
; ^^^^^^^^^^^^^
; SP is now here
proc showScreen
    push bp
    mov bp, sp

    push dx
 
	mov dx, [bp + 4]
	mov [BmpLeft], 0
	mov [BmpTop], 0
	mov [BmpColSize], 320
	mov [BmpRowSize], 240
	
	call OpenShowBmp
	pop dx

    pop bp
	ret 2
endp showScreen



proc menuScreen
    push offset MENU_IMAGE
    call showScreen
    ret
endp menuScreen


proc gameScreen
    call setupGameScreen
    call playGame
    ret
endp gameScreen


proc loseScreen
    push offset MENU_IMAGE
    call showScreen
    ret
endp loseScreen


proc winScreen
    push offset MENU_IMAGE
    call showScreen
    ret
endp winScreen
