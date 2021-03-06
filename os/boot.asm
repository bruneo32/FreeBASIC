[org 0x7c00]
[bits 16]

; FAT12
BPB:
    jmp START
    nop
	
	db 'FreeBAS '				; OEM, 8 bytes
	dw 512						; bytes per sector
	db 1						; sectors per cluster
	dw 1						; reserved sector count
	db 0						; number of FATs
	dw 0						; root directory entries
	dw 2880						; total sectors in drive
	db 0xF0						; media byte
	dw 0						; sectors per fat
	dw 18						; sectors per track
	dw 2						; number of heads
	dd 0						; hidden sector count
	dd 0						; number of sectors huge
EBPB: ; -------------------------------------------------
	db 0						; drive number
	db 0						; reserved
	db 0x69						; signature, maybe 0 or 29 or 28
	dd 0						; volume ID
	db 'System Disk'			; volume label, 11 bytes
	db 'BRFS    '				; file system type, 8 bytes
BRFS: ; -------------------------------------------------
	db 0x01 ; LABELING			; 00: Not BRFS, 01: ASCII, 02: UTF-8
	db 0x02 ; Pointer size (in bytes)
	db 0x00 ; Attributes size (in bytes)

; CODE
START:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Crear stack y demás cosas iniciales
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SYSTEM_SPACE equ 0x1000
xor ax, ax
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax

mov bx, 0x1000
mov ebx, 0x00001000 ; x86-64 machines won't work just with SP, they need ESP
cli
mov ss, ax
mov bp, bx
mov ebp, ebx ; For x86-64 machines
mov sp, bx-1
mov esp, ebx-1 ; For x86-64 machines
sti

mov [BOOT_DRIVE], dl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Leer segundo sector en SYSTEM_SPACE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SECTORS equ 0x20 ; Sectors to read. (ver: main.asm ~final)
xor ax, ax ; Reset disk
int 13h

xor bx, bx
mov es, bx
mov bx, SYSTEM_SPACE
mov al, SECTORS
mov ch, 0x00 ; C
mov dh, 0x00 ; H
mov dl, [BOOT_DRIVE]
mov cl, 0x03 ; Empezar en el sector 3, porque el 1 es el BOOT, y el 2 el ROOT

mov ah, 0x02 ; Read Disk int 13h/02h
int 13h
jc DiskError

mov dh, SECTORS
cmp dh, al ; Si no ha leido bien: Error
jnz DiskError
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Saltar a la posición de memoria del OS
; Le vamos a pasar el BOOT_DRIVE para
; que pueda obtener los parametros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov dl, [BOOT_DRIVE]
jmp 0:SYSTEM_SPACE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Terminar cualquier ejecucion
cli
hlt

; VARIABLES Y FUNCIONES
BOOT_DRIVE:
	db 0
str_diskerror:
	db 'Disk Read Error. System Halted.',0

DiskError:
	mov si, str_diskerror
	call PrintString
	cli
	hlt

; PrintString
PrintString:
	; SI: String adress
	mov ah, 0x0e
	.loop:
		cmp [si], byte 0
		jz .exitloop
		
		mov al, [si]
		xor bx, bx
		int 0x10
		
		inc si
		jmp .loop
	.exitloop:
	ret

; Firma del BOOT
times 510-($-$$) db 0
db 0x55,0xaa

; ROOT
ROOT:
db 'autorun.cmd',0x1c,0x00,0x31
db 'hola.txt',0x1c,0x00,0x27
db 'FOLDER',0x1d,0x00,0x28
db 'default.tmp',0x1c,0x00,0x30
db 'appleii.tmp',0x1c,0x00,0x29
db 'C64.tmp',0x1c,0x00,0x2a

times 512-($-ROOT) db 0