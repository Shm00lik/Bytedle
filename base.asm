IDEAL

MODEL small
STACK 256


DATASEG
	include "utils/dataseg.asm"
	
CODESEG
    ORG 100h
start:
	mov ax, @data
	mov ds,ax
	mov es,ax

	
	; call showMenuImage
	
	call mainLoop

EXIT:
    
	mov ax, 4C00h ; returns control to dos
  	int 21h
  
  
;---------------------------
; Procudures area
;---------------------------
include "utils/screenUtils.asm"
include "utils/ShowBmp.asm"


proc mainLoop
	mov ax, offset correctWord
	mov cx, 5

	@@loop:
		call getUserGuess
		call checkColors
		call checkWin

		cmp [isWin], 1
		je @@win

	jmp @@loop

	@@win:
		mov ax, 3339h

	@@end:
		ret


endp mainLoop


proc getUserGuess
	push ax
	push bx
	push cx

	mov cx, 5
	mov bx, offset userGuess

	@@getLetter:
		xor ax, ax

		mov ah, 01h
		int 21h

		; SOMETIMES SETS AL TO 41???
		
		cmp al, "a"
		jl @@getLetter

		cmp al, "z"
		jg @@getLetter

		mov [bx], al

		inc bx
	 loop @@getLetter

	pop cx
	pop bx
	pop ax

	ret
endp getUserGuess


proc checkColors
	push ax
	push bx
	push cx
	push si
	push di

	mov cx, 5
	
	mov si, offset userGuess
	mov di, offset colors
	mov bx, offset correctWord

	@@loop:
		mov ax, [si]

		cmp al, [bx]
		je @@setGreenColor

		push bx
		push cx

		mov [letterFound], 0
		mov bx, offset correctWord
		mov cx, 5

		@@innerLoop:
			cmp al, [bx]
			je @@letterFound
			
			jmp @@continueInnerLoop

			@@letterFound:
			mov [letterFound], 1
			jmp @@continueAfterInnerLoop

		@@continueInnerLoop:
			inc bx
			loop @@innerLoop


		@@continueAfterInnerLoop:
			pop cx
			pop bx

			cmp [letterFound], 1
			je @@setYellowColor
		
		@@setWhiteColor:
			mov [word di], "w"
			jmp @@continueAfterSettingColor

		@@setYellowColor:
			mov [word di], "y"
			jmp @@continueAfterSettingColor


		@@continueAfterSettingColor:
			inc bx
			inc si
			inc di

			jmp @@continueLoop

		@@setGreenColor:
			mov [word di], "g"
			jmp @@continueAfterSettingColor

	@@continueLoop:
		loop @@loop

	pop di
	pop si
	pop cx
	pop bx
	pop ax
	ret
endp checkColors


proc checkWin
	push ax
	push cx
	push si

	mov si, offset colors
	mov cx, 5
	
	@@loop:
		mov ax, [si]

		cmp al, "g"
		jne @@notWin

		inc si
	loop @@loop

	@@win:
		mov [isWin], 1
		jmp @@end

	@@notWin:
		mov [isWin], 0
		jmp @@end

	@@end:
		pop si
		pop cx
		pop ax
		ret
endp checkWin


proc showMenuImage
	push dx
	call SetGraphic
 
	mov dx, offset MENU_IMAGE
	mov [BmpLeft], 0
	mov [BmpTop], 0
	mov [BmpColSize], 320
	mov [BmpRowSize] ,200
	
	call OpenShowBmp
	pop dx
	
	ret
endp showMenuImage

END start






;-----------------------
; 		  TODO:
; 1. adding graphics
; 2. to actually check the program :( ---> DONE AT 5/5/22
; 3. adding screens
; 4. 
;-----------------------