[org 0x7e00]

BasicSpace equ 0xAA00
GeneralSpace equ 0x10000


mov [BOOT_DRIVE], dl
call __GetDriveParameters

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
KIT: ; KIT, Kernel Interface Table
	dw PrintString
	dw PrintLn
	dw PrintStringLn
	dw GetPromptString
	dw _InputBuffer
	dw _ClearInputBuffer
	dw __ensure
	dw __more
	dw ExtendedStore
	dw ExtendedLoad
	
	times 32-($-KIT) db 0
	db 0x5a,0x7a ; KIT/MIT End Signature

BasicProgramCounter: dw BasicSpace


%include "templates/appleii.asm"
%include "kernel/kernel.asm"
%include "basic/mit.asm" ; Module Interface Table

times 16*512-($-$$) db 0
; ----------------------------------------
; 0x9e00
MIT:
incbin "basic/core.bin" ; Usar MIT

times 6*512-($-MIT) db 0
; ----------------------------------------
; 22 sectores, reservados para el sistema, lo siguiente será el sistema de archivos en el disco, pero en la memoria el programa BASIC

; 0xAA00 en memoria
; Aqui va el BasicSpace en RAM
; 9216 bytes hasta 0xCE00