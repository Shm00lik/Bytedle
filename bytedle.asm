IDEAL

MODEL small
STACK 256


DATASEG
	include "byUtils/byDatas.asm"
	
CODESEG
    ORG 100h
	include "byUtils/byMacros.asm"

	
start:
	mov ax, @data
	mov ds, ax
	mov es, ax

	initialize
	call mainLoop

EXIT:
	mov ax, 4C00h ; returns control to dos
  	int 21h


;---------------------------
; Procudures area
;---------------------------
include "byUtils/byScUtls.asm"
include "byUtils/byShwBmp.asm"
include "byUtils/byUtils.asm"
include "byUtils/byPages.asm"


proc mainLoop
	@@loop:
		checkTimer timer1, 4, setDesiredPage
		; call VSync
		cmp [stopScreen], 0
		jne @@loop

		call displayCurrentScreen
	jmp @@loop

	@@end:
	ret


endp mainLoop

;========================================================
;========================================================
;========================================================

proc playGame
	push cx

	mov cx, 5
	@@loop:
		; Getting new word from the user:
		call getNewWord

		; Checking for a win:
		call checkWin
		cmp [isWin], 1
		je @@win

		; If not a win, then checks for a loss:
		cmp [wordIndex], 6
		jne @@continueLoop

		; That means that the user lost:
		mov [currentScreen], 5
		mov [stopScreen], 0
		jmp @@continueLoop

		@@win:
		mov [currentScreen], 6
		mov [stopScreen], 0
		jmp @@end

		@@continueLoop:
	loop @@loop

	@@end:
	pop cx
	ret
endp playGame

;========================================================
;========================================================
;========================================================

proc getNewWord
	call getUserGuess
	call checkColors
	call saveGuessToHistory
	call displayNewGuess
	
	inc [wordIndex]

	@@end:
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

		; Getting the letter:
		mov ah, 08h
		int 21h
		
		; If it's backspace:
		cmp al, 8h
		je @@backspace

		; If it's enter:
		cmp al, 0dh
		je @@enter

		; Any other letter:
		cmp cx, 1
		je @@getLetter

		cmp al, "a"
		jl @@getLetter

		cmp al, "z"
		jg @@getLetter

		jmp @@continue

		@@backspace:
			; Preventing backspace on first letter:
			cmp cx, 6
			je @@getLetter

			; Setting the letter to be NONE, represented by "_":
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

proc basicGameScreenSetup
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
endp basicGameScreenSetup

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

proc setupGameScreen
	call clearScreen
	call basicGameScreenSetup
	call generateRandomWord
	mov [wordIndex], 1
	mov [currentScreen], 4
	ret
endp setupGameScreen

;========================================================
;========================================================
;========================================================



END start



;-----------------------
; 		  TODO:
; 1. adding lose screen!!
;-----------------------