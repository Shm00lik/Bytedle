IDEAL

MODEL small
STACK 256


DATASEG
	include "byUtils/byDatas.asm"
	
CODESEG
    ORG 100h
start:
	mov ax, @data
	mov ds, ax
	mov es, ax
	call SetGraphic

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; IF PROGRAM IS BROKEN, MAKE SURE TO CALL SetGraphic!! ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	; push offset wordHistory1
	; push 1
	; call displayWord
	call basicScreenSetup

	mov cx, 5
	@@loop:
		call getNewWord
	loop @@loop
	; call mainLoop

EXIT:
    
	mov ax, 4C00h ; returns control to dos
  	int 21h
  
  
;---------------------------
; Procudures area
;---------------------------
include "byUtils/byScUtls.asm"
include "byUtils/byShwBmp.asm"
include "byUtils/byUtils.asm"

proc mainLoop
	mov ax, offset correctWord
	mov cx, 5

	@@loop:
	
		; call clearScreen
		
		

		;call showMenuImage

		

		
		; call clearScreen
		; call getNewWord
		; call checkWin

		; cmp [isWin], 1
		; je @@win

	;loop @@loop

	@@win:
		mov ax, 3339h

	@@end:
		ret


endp mainLoop

;========================================================
;========================================================
;========================================================

proc getNewWord
	call getUserGuess
	call checkColors
	call saveGuessToHistory
	call displayNewGuess
	inc [wordIndex]
	ret
endp getNewWord

;========================================================
;========================================================
;========================================================

proc getUserGuess
	push ax
	push bx
	push cx
	push dx

	mov cx, 6
	mov bx, offset userGuess
	mov dx, 1

	@@getLetter:
		xor ax, ax

		mov ah, 01h
		int 21h

		; SOMETIMES SETS AL TO 41???
		cmp al, 8h
		je @@backspace

		cmp al, 0dh
		je @@enter

		cmp cx, 1
		je @@getLetter

		cmp al, "a"
		jl @@getLetter

		cmp al, "z"
		jg @@getLetter

		jmp @@continue

		@@backspace:
			cmp cx, 6
			je @@getLetter ; for prevent backspace on first letter

			mov ax, "_"
			push ax

			push "_"

			xor ax, ax
			mov al, [wordIndex]
			push ax

			dec dx
			push dx

			call displayLetterByColor

			inc cx
			dec bx
			jmp @@getLetter

		@@enter:
			cmp cx, 1
			jne @@getLetter

			jmp @@end

		@@continue:
		mov [bx], al

		mov ah, 0
		push ax

		push "w"

		xor ax, ax
		mov al, [wordIndex]
		push ax

		push dx
		call displayLetterByColor

		inc bx
		inc dx
	loop @@getLetter

	@@end:
	pop dx
	pop cx
	pop bx
	pop ax

	ret
endp getUserGuess

;========================================================
;========================================================
;========================================================

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

;========================================================
;========================================================
;========================================================

proc saveGuessToHistory
	push ax
	push bx
	push cx
	push si

	cmp [wordIndex], 1
	je @@set1Word
	
	cmp [wordIndex], 2
	je @@set2Word
	
	cmp [wordIndex], 3
	je @@set3Word
	
	cmp [wordIndex], 4
	je @@set4Word
	
	cmp [wordIndex], 5
	je @@set5Word

	
	@@set1Word:
		mov bx, offset wordHistory1
		jmp @@continue
	
	@@set2Word:
		mov bx, offset wordHistory2
		jmp @@continue
		
	@@set3Word:
		mov bx, offset wordHistory3
		jmp @@continue
		
	@@set4Word:
		mov bx, offset wordHistory4
		jmp @@continue
		
	@@set5Word:
		mov bx, offset wordHistory5
		jmp @@continue


	@@continue:
	
	mov si, offset userGuess
	
	mov cx, 5
	
	@@loopWord:
		mov al, [si]
		mov [bx], al
		inc bx
		inc si
	loop @@loopWord
	
	
	mov si, offset colors
	
	mov cx, 5
	
	@@loopColor:
		mov al, [si]
		mov [bx], al
		inc bx
		inc si
	loop @@loopColor
	
	pop si
	pop cx
	pop bx
	pop ax
	ret
endp saveGuessToHistory

;========================================================
;========================================================
;========================================================

proc displayNewGuess
	push bx
	call setBXToCurrentWordOffset

	push DELAY_BETWEEN_LETTERS
	push bx

	xor bx, bx
	mov bl, [offset wordIndex]
	push bx
	call displayWord

	pop bx

	ret
endp displayNewGuess

;========================================================
;========================================================
;========================================================

proc setBXToCurrentWordOffset
	cmp [wordIndex], 1
	je @@set1Word
	
	cmp [wordIndex], 2
	je @@set2Word
	
	cmp [wordIndex], 3
	je @@set3Word
	
	cmp [wordIndex], 4
	je @@set4Word
	
	cmp [wordIndex], 5
	je @@set5Word

	
	@@set1Word:
		mov bx, offset wordHistory1
		jmp @@end
	
	@@set2Word:
		mov bx, offset wordHistory2
		jmp @@end
		
	@@set3Word:
		mov bx, offset wordHistory3
		jmp @@end
		
	@@set4Word:
		mov bx, offset wordHistory4
		jmp @@end
		
	@@set5Word:
		mov bx, offset wordHistory5
		jmp @@end

	@@end:
	ret
endp setBXToCurrentWordOffset

;========================================================
;========================================================
;========================================================

proc basicScreenSetup
	push cx

	mov cx, 5
	@@loop:
		push 0
		push offset defaultWord
		push cx
		call displayWord
	loop @@loop

	pop cx

	ret
endp basicScreenSetup

;========================================================
;========================================================
;========================================================

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

;========================================================
;========================================================
;========================================================

proc showMenuImage
	push dx
 
	mov dx, offset MENU_IMAGE
	mov [BmpLeft], 0
	mov [BmpTop], 0
	mov [BmpColSize], 320
	mov [BmpRowSize], 240
	
	call OpenShowBmp
	pop dx
	
	ret 2
endp showMenuImage


END start




;-----------------------
; 		  TODO:
; 1. adding graphics
; 2. to actually check the program :( ---> DONE AT 5/5/22
; 3. adding screens
; 4. 
;-----------------------