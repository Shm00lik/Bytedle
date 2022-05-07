OneBmpLine 	db 320 dup (0)  ; One Color line read buffer
   
ScrLine 	db 200 dup (0)  ; One Color line read buffer

;BMP File data
FileName 	db '' ,0

FileHandle	dw ?
Header 	    db 54 dup(0)
Palette 	db 400h dup (0)


BmpFileErrorMsg    	db 'Error At Opening Bmp File ', '', 0dh, 0ah,'$'
ErrorFile           db 0
BB db "BB..",'$'
; array for mouse int 33 ax=09 (not a must) 64 bytes

 
 
Color db ?
Xclick dw ?
Yclick dw ?
Xp dw ?
Yp dw ?
SquareSize dw ?
 
BmpLeft dw ?
BmpTop dw ?
BmpColSize dw ?
BmpRowSize dw ?


MENU_IMAGE db "bytedleImages/menu.bmp", 0


correctWord db "homer"
userGuessString db "xx00000x"
userGuess db "hello"
colors db "wwwww"
letterFound db 0
isWin db 0