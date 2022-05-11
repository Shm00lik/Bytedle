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



MENU_IMAGE db "byImages/byMenu.bmp", 0
CURRENT_LETTER_PATH db "byImages/___.bmp"




FIRST_WORD_Y            equ 4
FIRST_LETTER_X          equ 67
LETTERS_DIFF_X          equ 38
LETTERS_DIFF_Y 	        equ 39
LETTER_IMAGE_SIZE       equ 32
DELAY_BETWEEN_LETTERS   equ 300




correctWord   db "cabab"
userGuess     db "     "
colors        db "     "
letterFound   db 0
isWin         db 0
wordIndex     db 1
defaultWord   db "__________"
wordHistory1  db "     wwwww"
wordHistory2  db "     wwwww"
wordHistory3  db "     wwwww"
wordHistory4  db "     wwwww"
wordHistory5  db "     wwwww"