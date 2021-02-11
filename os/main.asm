[org 0x7e00]

times 32 db 0 ; KIV, Kernel Interrupt Vector

BasicSpace equ 0x9e00 ; 16 sectores después

; TemplateSpace equ ????
; call _TemplateSpace

call Start ; Temporal

MainLoop:
	mov si, str_pretext
	call PrintString
	
	call GetPromptString
	call PrintLn
	
	; EJECUTAR COMANDO
	call TryCommandOrBas
	
	call PrintLn
	jmp MainLoop

; Si por algún motivo se pasa, detener
cli
hlt

times 256-($-$$) db 0

; 0x7d00
KIV: ; KIV, Kernel Interrupt Vector
	dw PrintStringLn
	
	times 32-($-KIV) db 0
	db 0x5a,0x7a ; KIV End Signature

BasicProgramCounter: dw BasicSpace

%include "templates/appleii.asm"
%include "kernel/kernel.asm"

BasicReorder:
	;incbin "basic/reorder.bin"
	ret
BasicInterpret:
	incbin "basic/core.bin"

; ----------------------------------------
times 8192 - ($-$$) db 0
; 8192 son 16 sectores, reservados para el sistema, lo siguiente será el sistema de archivos en el disco.

; 0x9e00
; Aqui va el BasicSpace en RAM