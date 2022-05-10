proc clearScreen
	push ax
	push cx

	mov ax, 0B800h
	mov es, ax
	mov cx, 4000

	@@clear:
		; clears the screen
		mov di, cx
		mov ah, 0b
		mov al, ''
		mov [es:di], ax
		loop @@clear
	
	pop cx
	pop ax
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
	
	LETTER_INDEX 1 ;equ [bp + 4]
	WORD_INDEX 	  1 ;equ [bp + 6]
	LETTER_COLOR "g" ; equ [bp + 8]
	LETTER 		 "a"; equ [bp + 10]

	
	push dx
	call SetGraphic
 
	mov dx, offset CURRENT_LETTER_PATH
			
	push ax
	push cx
	
	mov ax, FIRST_LETTER_X
	mov cx, LETTER_INDEX
	
	@@XLoop:
		add ax, LETTERS_DIFF_X
	loop @@XLoop
	
	mov [BmpLeft], ax
	
	
	mov ax, FIRST_WORD_Y
	mov cx, WORD_INDEX
	
	@@YLoop:
		add ax, LETTERS_DIFF_Y
	loop @@YLoop
	
	mov [BmpTop], ax
	
	pop cx
	pop ax
	
	
	mov [BmpColSize], LETTER_IMAGE_SIZE
	mov [BmpRowSize], LETTER_IMAGE_SIZE
	
	call OpenShowBmp
	
	pop dx

	
	
	pop bp
	ret 8 
	
endp displayLetterByColor


