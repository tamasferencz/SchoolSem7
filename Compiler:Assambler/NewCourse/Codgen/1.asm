global main						; Name of the entry point for executing the file
extern write_unsigned			; Name of a code label, which is defined in another file

section .text					; code section
main:							; one of the code labels, here specifically the entry point because of the first line
	mov ebx,1					; moving 1 to the ebx register
	mov ecx,2					; moving 2 to the ecx register
	mov eax,ebx					; moving ebx registers value to the eax register
	add eax,ecx					; eax += ecx
	push eax					; coping eax's value to the runtime stack
	call write_unsigned			; 'function call', jumping to the code labal named write_unsigned, when finished jumping back
	add esp,4					; clearing the top 4 bytes from the runtime stack
	ret							; ending the execution