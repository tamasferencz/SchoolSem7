global main
extern write_unsigned

section .data
X   dd  5
Y   dd  10

section .bss
Z   resd 4

section .text
main:
    mov eax,[X]
    xor edx,edx     ; mov edx,0
    mul dword [Y]   ; edx|eax := eax * [Y]
    mov [Z],eax
    
    push dword [Z]
    call write_unsigned
    add esp,4
    
	ret
