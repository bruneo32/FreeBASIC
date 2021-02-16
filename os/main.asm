[org 0x7e00]

BasicSpace equ 0xAA00
GeneralSpace equ 0x10000


mov [BOOT_DRIVE], dl
call __GetDriveParameters

mov byte [BasicSpace], byte 0

xor ah, ah ; Set video mode
mov al, [VideoMode]
int 10h

call ConsoleClear ; Clear
call CustomConsole ; Clear + TEMPLATE


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

VideoMode:
	; ==========================================================================
	;                    Table of Video Modes (Only TEXT MODES)
	; ==========================================================================
	;                                                                   Buffer
	; Mode     Type        Resolution      Adapter(s)      Colors       Address
	; ==========================================================================
	; 00h     Text          40 x 25      All but MDA       16 gray       B8000
	; 01h     Text          40 x 25      All but MDA   16 fore/8 back    B8000
	; 02h     Text          80 x 25      All but MDA       16 gray       B8000
	; 03h     Text          80 x 25      All but MDA   16 fore/8 back    B8000
	; 07h     Text          80 x 25        MDA,EGA          b/w          B0000
	; ==========================================================================
	db 0x03

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


%include "templates/c64.asm"
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
; 22015 bytes hasta 0xFFFF