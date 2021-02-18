_BRFS_TRS_ equ 0x7a00 ; 512 antes de 0x7c00
_BRFS_TWS_ equ 0x7800 ; 512 antes de 0x7a00
_CurrentDisk:
	db 0
_CD:
	db 0x00,0x01 ; Root
_str_diskerror:
	db 'Disk Read Error',0

; FUNCTIONS
_lba: db 0,0
_lba_C: db 0
_lba_H: db 0
_lba_S: db 0
_SectorsPerTrack: db 0
_NumHeads: db 0
_NumCillinders: db 0
LBA2CHS:
	; BX: Sector to read
	
	pusha
	
	; Sector = (LBA/SectorsPerTrack) Remainder value + 1
	; Cylinder = (LBA/SectorsPerTrack)/NumHeads (Take Remainder value)
	; Head = (LBA/SectorsPerTrack)/NumHeads (Take quotient value)
	
	mov [_lba], bh
	mov [_lba+1], bl
	
	xor dx, dx
	xor ax, ax
	
	;	S
	mov ax, bx
	mov bl, [_SectorsPerTrack]
	xor dx, dx
	div bl ; Remainder AH
	inc ah
	mov [_lba_S], ah
	
	;	C
	mov bh, [_lba]
	mov bl, [_lba+1]
	mov ax, bx
	mov bl, [_SectorsPerTrack]
	xor dx, dx
	div bl ; Cociente: AL
	xor ah, ah
	mov bl, [_NumHeads]
	xor dx, dx
	div bl
	
	mov [_lba_C], ah ; Resto
	
	;	H
	mov [_lba_H], al ; Cociente
	
	popa
	ret
__GetDriveParameters:
	; DL - Drive Number
	pusha
	
	mov ah, 0x08
	int 13h
	jc .end
	
	mov [_NumCillinders], ch
	mov [_SectorsPerTrack], cl
	mov [_NumHeads], dh
	
	.end:
	popa
	ret
_BRFS_ReadSector:
	pusha
	; Adress in BH:BL
	call LBA2CHS
	
	mov bx, _BRFS_TRS_
	mov cx, 512
	.clear:
		cmp cx, word 0
		jz .exitClear
		dec cx
		
		mov [bx], byte 0
		
		inc bx
		jmp .clear
	.exitClear:
	
	clc
	xor ax, ax ; Reset
	int 13h
	
	xor bx, bx
	mov es, bx
	mov bx, _BRFS_TRS_
	mov al, 0x01 ; Sectors to read
	mov ch, [_lba_C] ; Cilindro.
	mov dh, [_lba_H] ; Cabeza.
	mov cl, [_lba_S] ; Sector
	mov dl, [_CurrentDisk]
	
	mov ah, 0x02 ; Read Disk int 13h/02h
	int 13h
	jc .errorin
	jmp .end
	
	.errorin:
	call DiskError
	stc
	
	.end:
	popa
	ret
_BRFS_ReadSectorCD:
	mov bh, [_CD]
	mov bl, [_CD+1]
	call _BRFS_ReadSector
	ret
DiskError:
	clc
	xor ax, ax ; Reset
	int 13h
	mov si, _str_diskerror
	call PrintStringLn
	
	ret

_BRFS_GetElementFromDir:
	; BL: Stop char (0x1c o 0x1d).
	; SI: Query
	
	jmp .starti
	
	; vars
	._c:	dw 0
	.almac:
		db 0,0
	.stopc:
		db 0
	
	.starti:
	mov [.stopc], bl
	mov bx, si
	mov [.almac], bh
	mov [.almac+1], bl
	mov bx, word [_CD]
	mov [._c], bh
	mov [._c+1], bl
	.starti2:
	mov bh, [.almac]
	mov bl, [.almac+1]
	mov si, bx
	xor dx, dx
	mov di, _BRFS_TRS_
	.loop:
		cmp di, _BRFS_TRS_+510
		jae .exitLoop ; Hay que leer más sectores
		
		mov bl, [si]
		cmp bl, [di]
		jnz .fnext
		
		; Si coinciden...
		inc si
		
		mov bl, byte 0
		cmp bl, [si]
		jz .GET
		mov bl, ' ' ; Espacio para separar argumentos en los comandos
		cmp bl, [si]
		jz .GET
		
		jmp .next
		
		.GET:
		inc di
		mov bl, [.stopc]
		cmp bl, [di]
		jnz .fnext
		
		mov dh, [di+1]
		mov dl, [di+2]
		clc ; Encontrado
		jmp .end
		
		.fnext:
		mov bh, [.almac]
		mov bl, [.almac+1]
		mov si, bx
		.next:
		inc di
		jmp .loop
	.exitLoop:
	mov di, _BRFS_TRS_+510
	xor bh, bh
	cmp bh, [di]
	jnz .leermas
	cmp bh, [di+1]
	jz .finale
	mov bh, byte 1
	cmp bh, [di+1]
	jz .leermas1
	jmp .leermas ; ELSE
	
	.finale:
	stc ; No la encontró
	jmp .end
	
	.leermas1:
	mov bx, word [._c] ; Lo habiamos guardado en DX
	inc bx
	mov [._c], bh
	mov [._c+1], bl
	call _BRFS_ReadSector
	jmp .starti2
	
	.leermas:
	mov di, _BRFS_TRS_+510
	mov bh, [di]
	mov bl, [di+1]
	call _BRFS_ReadSector
	jmp .starti2
	
	
	.end:
	; DX: SECTOR OF
	; CF if elm not exist
	ret

_BRFS_MoveReaded:
	; DI: Start address in memory
	pusha
	mov si, _BRFS_TRS_
	.loop:
		cmp si, _BRFS_TRS_+512
		jae .exitLoop
		
		mov bh, [si]
		mov byte [di], bh
		
		inc di
		inc si
		jmp .loop
	.exitLoop:
	
	popa
	ret