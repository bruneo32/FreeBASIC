[org 0x7e00]

BasicSpace equ 0x9e00 ; 16 sectores después


mov [BOOT_DRIVE], dl
call __GetDriveParameters


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

BOOT_DRIVE:	db 0

times 256-($-$$) db 0 ; offset hasta el 7d00

; 0x7f00
KIT: ; KIT, Kernel Interrupt Vector
	dw PrintString
	dw PrintLn
	dw PrintStringLn
	dw GetPromptString
	dw _InputBuffer
	dw __ensure
	dw __more
	
	times 32-($-KIT) db 0
	db 0x5a,0x7a ; KIT End Signature

BasicProgramCounter: dw BasicSpace


%include "templates/appleii.asm"
%include "kernel/kernel.asm"

times 9*512-($-$$) db 0
; ----------------------------------------
; 0x9000

BasicInterpret:
	incbin "basic/interpret.bin"
	ret ; No deberia poder llegar hasta aqui

times 7*512-($-BasicInterpret) db 0
; ----------------------------------------
; 16 sectores, reservados para el sistema, lo siguiente será el sistema de archivos en el disco, pero en la memoria el programa BASIC

; 0x9e00 en memoria
; Aqui va el BasicSpace en RAM