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