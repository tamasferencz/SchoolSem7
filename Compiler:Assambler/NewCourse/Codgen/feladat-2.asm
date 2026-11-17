; Calculating absolute values for signed numbers
global main
extern read_signed
extern write_signed

section .text
main:
    call read_signed
    cmp eax,0
    jge greater_or_equal
    neg eax
greater_or_equal:
    
    push eax
    call write_signed
    add esp,4
    
	ret
