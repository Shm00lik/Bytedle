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


BACKGROUND_IMAGE_PATH  db "byImages/byBack.bmp"          , 0
MENU_IMAGE             db "byImages/screens/menu_0.bmp"  , 0
QUIT_IMAGE             db "byImages/screens/quit.bmp"    , 0
LEARN_IMAGE            db "byImages/screens/learn.bmp"   , 0
LEARN_BACK_IMAGE       db "byImages/screens/learnBck.bmp", 0
WIN_IMAGE              db "byImages/screens/win.bmp"     , 0


CURRENT_LETTER_PATH    db "byImages/letters/___.bmp"    , 0
RAND_WORD_PATH         db "byUtils/byRaWord/byWord.txt" , 0
RAND_WORD_FLAG_PATH    db "byUtils/byRaWord/byFlag.txt" , 0



FIRST_WORD_Y            equ 4
FIRST_LETTER_X          equ 67
LETTERS_DIFF_X          equ 38
LETTERS_DIFF_Y 	        equ 39
LETTER_IMAGE_SIZE       equ 32
DELAY_BETWEEN_LETTERS   equ 300


MENU_SCREEN_MAIN  equ 0
MENU_SCREEN_PLAY  equ 1
MENU_SCREEN_LEARN equ 2
MENU_SCREEN_QUIT  equ 3
GAME_SCREEN       equ 4
LOSE_SCREEN       equ 5
WIN_SCREEN        equ 6



correctWord   db "     "
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

currentScreen db 0

; 0 - menu: main
; 1 - menu: play
; 2 - menu: learn
; 3 - menu: quit
; 4 - game
; 5 - lose
; 6 - win
; 7 - learn
; 8 - learn: back
; 9 - quit

stopScreen    db 0


timer1 dw ?

lastCursorX db 0
lastCursorY db 0