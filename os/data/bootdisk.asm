[org 0x7c00]
[bits 16]

; FAT12
BPB:
	jmp START
	nop
	
	; FAT12 for BRFS
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
	db 'NO LABEL   '			; volume label, 11 bytes
	db 'BRFS    '				; file system type, 8 bytes
BRFS: ; -------------------------------------------------
	db 0x01 ; LABELING			; 00: Not BRFS, 01: ASCII, 02: UTF-8
	db 0x02 ; Pointer size (in bytes)
	db 0x00 ; Attributes size (in bytes)

; CODE
START:

jmp $ ; HANG

times 510-($-$$) db 0
db 0x55,0xaa

ROOT:
db 'file',0x1c,0x00,0x05

times 4*512-($-ROOT) db 0

file:
db '10 Printi'

times 512-($-file) db 0