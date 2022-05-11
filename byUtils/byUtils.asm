; STACK
;  miliseconds
;  ^^^^^^^^^^^
; SP is now here
proc sleep_ms
    push bp
    mov bp, sp

    MILISECONDS equ [bp + 4]

    push ax
    push bx
    push cx
    push dx

    xor cx, cx
    xor dx, dx

    mov bx, MILISECONDS
    mov ax, 1000
    
    mul bx

    cmp dx, 0
    jl @@continue

    mov cx, dx

    @@continue:
    mov dx, cx
    
    mov ax, 8600h
    int 15h

    pop dx
    pop cx
    pop bx
    pop ax

    pop bp
    ret 2
endp sleep_ms

macro sleepMS miliseconds
    push miliseconds
    call sleep_ms
endm sleepMS