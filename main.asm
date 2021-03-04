[org 0x1000]

BasicSpace equ 0x7e00
ProgramSpace equ 0xce00
GeneralSpace equ 0x10000
BASCORE_SIZE equ 5

mov [BOOT_DRIVE], dl
mov [_CurrentDisk], dl ; Set Disk
call __GetDriveParameters

mov byte [BasicSpace], byte 0

xor ah, ah ; Set video mode
mov al, [VideoMode]
int 10h

call ConsoleClear


mov di, 0x5000
mov bx, word 0x22
mov cl, BASCORE_SIZE
.loadModule:
	cmp cl, byte 0
	jz .exitLoadmodule
	pusha
	
	call _BRFS_ReadSector
	call _BRFS_MoveReaded
	
	popa
	add di, 512
	inc bx
	dec cl
	jmp .loadModule
.exitLoadmodule:

;;;;;;;;;;; AUTORUN ;;;;;;;;;;;
call _BRFS_ReadSectorCD
jc MainLoop

; Buscar si existe
mov bl, 0x1c ; Fichero
mov si, str_com_autorun+4 ; "autorun.cmd"
call _BRFS_GetElementFromDir
jc MainLoop ; No existe

call _ClearInputBuffer
mov di, _InputBuffer
mov si, str_com_autorun
._autorunLoop:
	cmp byte [si], byte 0
	jz ._exitAutorunLoop
	
	mov bl, byte [si]
	mov byte [di], bl
	
	inc si
	inc di
	jmp ._autorunLoop
._exitAutorunLoop:

call _con_exec
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MainLoop:
	call PrintLn
	mov si, str_pretext
	call PrintString
	
	call GetPromptString
	call PrintLn
	
	; EJECUTAR COMANDO
	call TryCommandOrBas
	
	jmp MainLoop

; Si por algún motivo se pasa, detener
cli
hlt

str_com_autorun:
	db 'COM autorun.cmd',0

; System required variables
BOOT_DRIVE:	db 0

COLOR:
	; See "COLOR ?"
	db 0x1F
SafeRect:
	;  ROW  COL
	db 0x00,0x00 ; Top-left corner
	db 0x18,0x4f ; Bottom-right corner
str_pretext:
	times 6-($-str_pretext) db 0
	db 0
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

times 256-($-$$) db 0 ; offset hasta el 0x1100

; 0x1100
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
	dw BasicProgramCounter
	dw MainLoop
	
	times 64-($-KIT) db 0
	db 0x5a,0x7a ; KIT/MIT End Signature

BasicProgramCounter: dw BasicSpace

%include "kernel/kernel.asm"
%include "basic/mit.asm" ; Module Interface Table

times 32*512-($-$$) db 0