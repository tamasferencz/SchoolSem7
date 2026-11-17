; Storing 5 in memory, increment it by one, and print out
global main
extern write_unsigned

section .data
X   dd  5
Y   dd  10

section .bss
Z   resd 1
; could be resw 2
; or resb 4

section .text
main:
    inc dword [X]
    
    ; printing out result:    
    push dword [X]
    call write_unsigned
    add esp,4
    
    ret
