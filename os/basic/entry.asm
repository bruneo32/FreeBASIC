; entry.asm: interpreter entry point
bits 16

extern interpret
global basicprogram
global start

start:
	mov WORD [basicprogram], si
	call interpret
	ret
	
basicprogram:
	dw 0x0000
	
%include "kiv.asm"