; Lets write out 10, instead of 5
global main
extern write_unsigned

section .data
X   dd  5
Y   dd  10

section .bss
Z   resd 4

section .text
main:
    mov eax,[Y]
    mov [X],eax
    ; mov dword [X],[Y]     WRONG!
    
    push dword [X]
    call write_unsigned
    add esp,4
    
	ret
