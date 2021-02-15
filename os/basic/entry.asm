; entry.asm: interpreter entry point
bits 16

MIT:
	dw _list
	dw _interpret

	times 32-($-MIT) db 0
	db 0x5a,0x7a ; KIT/MIT End Signature

extern interpret
extern list

global _list
global _interpret
global kernarg
	
_list:
	mov WORD [kernarg], si	; list cmd arg
	call list
	ret
	
_interpret:
	mov WORD [kernarg], si	; basic program string
	call interpret
	;push _strxd
	;mov si, _strxd
	;call PrintStringLn
	ret
	
kernarg:
	dw 0x0000
	
_strxd:
	db 'Hola xd',0
	
%include "kit.asm"