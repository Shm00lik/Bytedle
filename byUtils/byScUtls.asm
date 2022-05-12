
proc clearScreen
	call SetGraphic

	push dx
 
	mov dx, offset BACKGROUND_IMAGE_PATH
	mov [BmpLeft], 0
	mov [BmpTop], 0
	mov [BmpColSize], 320
	mov [BmpRowSize], 240
	
	call OpenShowBmp
	pop dx

	ret
endp clearScreen


; STACK:
; letter
; color
; word index
; letter index
; ^^^^^^^^^^^^^
; SP is now here
proc displayLetterByColor
	push bp
	mov bp, sp
	
	LETTER 		 equ  [bp + 10]
	LETTER_COLOR equ  [bp + 8]
	WORD_INDEX 	 equ  [bp + 6]
	LETTER_INDEX equ  [bp + 4]

	push ax
	push bx
	
	mov bx, offset CURRENT_LETTER_PATH
	
	add bx, 17
	mov ax, LETTER
	mov [bx], al

	add bx, 2
	mov ax, LETTER_COLOR
	mov [bx], al

	push WORD_INDEX
	push LETTER_INDEX
	call displayLetter

	pop bx
	pop ax
	
	pop bp
	ret 8
endp displayLetterByColor


; STACK:
; word index
; letter index
; ^^^^^^^^^^^^^
; SP is now here
proc displayLetter
	push bp
	mov bp, sp
	
	WORD_INDEX 	 equ  [bp + 6]
	LETTER_INDEX equ  [bp + 4]

	push dx 
	mov dx, offset CURRENT_LETTER_PATH
	
	push ax
	push cx
	
	mov ax, FIRST_LETTER_X
	mov cx, LETTER_INDEX
	
	@@XLoop:
		add ax, LETTERS_DIFF_X
	loop @@XLoop
	sub ax, LETTERS_DIFF_X ; cuz first letter actualy starts at 0, but cx can't be 0 when looping

	mov [BmpLeft], ax
	
	
	mov ax, FIRST_WORD_Y
	mov cx, WORD_INDEX
	
	@@YLoop:
		add ax, LETTERS_DIFF_Y
	loop @@YLoop
	sub ax, LETTERS_DIFF_Y ; same like above
	
	mov [BmpTop], ax
	
	pop cx
	pop ax
	
	
	mov [BmpColSize], LETTER_IMAGE_SIZE
	mov [BmpRowSize], LETTER_IMAGE_SIZE
	
	call OpenShowBmp
	
	pop dx

	
	pop bp
	ret 4
endp displayLetter


; STACK:
; delay between letters
; word offset
; word index
; ^^^^^^^^^^^^^
; SP is now here
proc displayWord
	push bp
	mov bp, sp
	
	DELAY        equ [bp + 8]
	WORD_OFFSET  equ [bp + 6]
	WORD_INDEX   equ [bp + 4]
	
	push ax
	push bx
	push cx

	mov cx, 5

	@@loop:
		mov bx, WORD_OFFSET
		add bx, cx
		sub bx, 1

		mov ax, [bx]

		push ax

		add bx, 5
		mov ax, [bx]

		push ax
	
		push WORD_INDEX
		push cx
		call displayLetterByColor

		push DELAY
		call sleep_ms
	loop @@loop

	pop cx
	pop bx
	pop ax
	
	pop bp
	ret 6
endp displayWord

;========================================================
;========================================================
;========================================================

proc displayCurrentScreen
	cmp [currentScreen], 0
	je @@menuScreen

	cmp [currentScreen], 1
	je @@gameScreen

	cmp [currentScreen], 2
	je @@loseScreen

	cmp [currentScreen], 3
	je @@winScreen

	@@menuScreen:
	call menuScreen
	jmp @@end

	@@gameScreen:
	call gameScreen
	jmp @@end

	@@loseScreen:
	call loseScreen
	jmp @@end

	@@winScreen:
	call winScreen
	jmp @@end

	@@end:
	mov [stopScreen], 0
	ret 
endp displayCurrentScreen