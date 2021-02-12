[org 0x7c00]
[bits 16]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Crear stack y demás cosas iniciales
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PROGRAM_SPACE equ 0x7e00
xor ax, ax
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax

mov bx, 0x7a00 ; x7a00-x7c00 = BRFS-TMS
mov ebx, 0x00007a00
cli
mov ss, ax
mov sp, bx
mov esp, ebx
sti

mov [BOOT_DRIVE], dl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Leer segundo sector en PROGRAM_SPACE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SECTORS equ 0x10 ; Sectors to read. x10 = 16 dec (ver: main.asm ~final)
xor ax, ax ; Reset disk
int 13h

xor bx, bx
mov es, bx
mov bx, PROGRAM_SPACE
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
jmp PROGRAM_SPACE
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
db 'hola.txt',0x1c,0x00,0x12 ; sector18
db 'hola.txt',0x1d,0x00,0x12 ; sector18

times 512-($-ROOT) db 0