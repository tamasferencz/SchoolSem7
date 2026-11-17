; Reading two numbers, printing out the second number by first-number-times
global main
extern read_signed
extern write_signed

section .text
main:
    call read_signed
    mov ecx,eax
    
    push ecx    ; saving it to stack
    call read_signed
    pop ecx     ; reloading from stack
begining:
    cmp ecx,0
    je ending
    push eax    ; saving
    push ecx    ; because a function call can mess up eax, ecx and edx
    
    push eax
    call write_signed
    add esp,4
    
    pop ecx     ; reloading
    pop eax     ; reloading
    
    dec ecx
    jmp begining
ending:
    
    ; exiting
    ret
