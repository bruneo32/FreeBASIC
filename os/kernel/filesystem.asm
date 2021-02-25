_BRFS_TRS_ equ 0x7a00 ; 512 antes de 0x7c00
_BRFS_TWS_ equ 0x7800 ; 512 antes de 0x7a00
__unreadable_disk:	db 0
_CurrentLabel:
	times 11 db 0
	db 0
_CurrentDisk:
	db 0
_CD:
	db 0x00,0x01 ; Root
_FreeSector:
	db 0x00,0x00
_str_diskRerror:
	db 'Disk Read Error',0
_str_diskWerror:
	db 'Disk Write Error',0

; FUNCTIONS
_lba: db 0,0
_lba_C: db 0
_lba_H: db 0
_lba_S: db 0
_SectorsPerTrack: db 0
_NumHeads: db 0
_NumCillinders: dw 0
LBA2CHS:
	; BX: Sector to read
	
	pusha
	
	; Sector = (LBA/SectorsPerTrack) Remainder value + 1
	; Cylinder = (LBA/SectorsPerTrack)/NumHeads (Take Remainder value)
	; Head = (LBA/SectorsPerTrack)/NumHeads (Take quotient value)
	
	mov [_lba], bh
	mov [_lba+1], bl
	
	xor dx, dx
	
	;	S
	mov ax, bx
	mov bl, [_SectorsPerTrack]
	div bl ; Remainder AH
	inc ah
	mov [_lba_S], ah
	
	;	C
	mov bh, [_lba]
	mov bl, [_lba+1]
	mov ax, bx
	mov bl, [_SectorsPerTrack]
	div bl ; Cociente: AL
	xor ah, ah
	mov bl, [_NumHeads]
	div bl
	
	mov [_lba_C], ah ; Resto
	
	;	H
	mov [_lba_H], al ; Cociente
	
	popa
	ret
__GetDriveParameters:
	; DL - Drive Number
	pusha
	
	clc
	mov ah, 0x08
	int 13h
	jc .end
	; Returns: 
	; CH         Maximum value for cylinder (10-bit value;upper 2 bits in CL)
	; CL         Maximum value for sector
	; DH         Maximum value for heads
	
	mov [_NumHeads], dh
	
	push cx
	and cl, 00111111b
	mov [_SectorsPerTrack], cl
	pop cx
	
	and cl, 11000000b
	shr cl, 6
	ror cx, 8
	mov [_NumCillinders],ch
	mov [_NumCillinders+1],cl
	
	xor bx,bx
	call _BRFS_ReadSector
	
	mov cl, byte 11
	mov si, _BRFS_TRS_+43
	mov di, _CurrentLabel
	.loop:
		cmp cl, byte 0
		jz .exitLoop
		
		mov bl, byte [si]
		mov byte [di], bl
		
		inc si
		inc di
		dec cl
		jmp .loop
	.exitLoop:
	mov si, _BRFS_TRS_+62
	cmp byte [si], 0x01
	jnz .unreadable
	inc si
	cmp byte [si], 0x02
	jnz .unreadable
	inc si
	cmp byte [si], 0x00
	jnz .unreadable
	
	mov byte [__unreadable_disk], 0x00
	
	jmp .end
	
	.unreadable:
	mov byte [__unreadable_disk], 0x01
	
	.end:
	popa
	ret
_BRFS_ReadSector:
	pusha
	; Adress in BH:BL
	call LBA2CHS
	
	call _BRFS_ClearTRS
	
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
	call DiskReadError
	stc
	
	.end:
	popa
	ret
_BRFS_ReadSectorCD:
	mov bh, [_CD]
	mov bl, [_CD+1]
	call _BRFS_ReadSector
	ret
DiskReadError:
	clc
	xor ax, ax ; Reset
	int 13h
	mov si, _str_diskRerror
	call PrintStringLn
	
	jmp word [0x1116] ; Exit
	ret
DiskWriteError:
	clc
	xor ax, ax ; Reset
	int 13h
	mov si, _str_diskWerror
	call PrintStringLn
	
	jmp word [0x1116] ; Exit
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
	.veto:
		db 0
	
	.starti:
	mov [.stopc], bl
	mov bx, si
	mov [.almac], bh
	mov [.almac+1], bl
	mov bx, word [_CD]
	mov [._c], bh
	mov [._c+1], bl
	mov byte [.veto], 0x00
	.starti2:
	mov bh, [.almac]
	mov bl, [.almac+1]
	mov si, bx
	xor dx, dx
	mov di, _BRFS_TRS_
	.loop:
		cmp di, _BRFS_TRS_+510
		jae .exitLoop ; Hay que leer más sectores
		
		cmp [di], byte 0
		jz .next
		
		cmp byte [.veto], byte 0
		jz .ok
		
		cmp [di], byte 0x1c
		jz .fod
		cmp [di], byte 0x1d
		jz .fod
		
		jmp .next
		
		.fod:
		add di, 2
		mov byte [.veto], 0x00
		jmp .next
		
		.ok:
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
		mov byte [.veto], 0x01
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
	mov bx, word [._c]
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

_BRFS_GetFreeSector:
	pusha
	
	mov [_FreeSector], word 0
	mov bx, 0x001d ; OS
	
	.read:
		call _BRFS_ReadSector
		cmp byte [_BRFS_TRS_], byte 0
		jz .GG
		
		cmp bx, 0xFFFF
		jz .end
		
		inc bx
		jmp .read
	.GG:
	mov [_FreeSector], bh
	mov [_FreeSector+1], bl
	.end:
	popa
	ret

_BRFS_ClearTRS:
	pusha
	mov si, _BRFS_TRS_
	.loop:
		mov [si], byte 0
		inc si
		cmp si, _BRFS_TRS_+512
		jb .loop
	popa
	ret
_BRFS_ClearTWS:
	pusha
	mov si, _BRFS_TWS_
	.loop:
		mov [si], byte 0
		inc si
		cmp si, _BRFS_TWS_+512
		jb .loop
	popa
	ret

_BRFS_CreateEntry:
	; SI:	Entry Name
	; BL:	Type (0x1c | 0x1d)
	; DI:	Sector
	
	pusha
	
	mov dx, word [_CD]
	
	mov word [._eind], si
	mov word [._esec], di
	mov word [._modsec], dx
	mov byte [._type], bl
	
	jmp .starti
	
	._type:	db 0
	._eind:	dw 0
	._esec:	dw 0
	._modsec:	dw 0
	
	.starti:
	call _BRFS_ReadSectorCD
	jc .end
	
	mov di, word [._eind]
	mov si, _BRFS_TRS_
	.loop:
		cmp si, _BRFS_TRS_+510
		jae .exitLoop
		
		cmp [si], byte 0x1c
		jz .n0
		cmp [si], byte 0x1d
		jnz .n1
		
		.n0:
		add si, 2
		jmp .next
		
		.n1:
		cmp si, _BRFS_TRS_+510
		jae .exitLoop
		
		cmp [si], byte 0
		jnz .next
		
		
		; Store
		mov bl, [di]
		mov [si], bl
		
		inc di
		cmp [di], byte 0
		jnz .next
		
		;PTR
		inc si
			cmp si, _BRFS_TRS_+510
			jae .exitLoop
		mov bl, byte [._type]
		mov byte [si], bl
		inc si
			cmp si, _BRFS_TRS_+510
			jae .exitLoop
		mov bl, byte [._esec]
		mov byte [si], bl
		inc si
			cmp si, _BRFS_TRS_+510
			jae .exitLoop
		mov bl, byte [._esec+1]
		mov byte [si], bl
		
		call .store
		jmp .end
		
		.next:
		inc si
		jmp .loop
	.exitLoop:
	mov si, _BRFS_TRS_+510
	; Leer mas
	
	jmp .end
	
	.store:
		mov bx, word [._modsec]
		rol bx, 8
		call LBA2CHS
		
		xor bx,bx
		mov es, bx
		mov bx, _BRFS_TRS_
		
		mov ch, [_lba_C] ; Cilindro.
		mov dh, [_lba_H] ; Cabeza.
		mov cl, [_lba_S] ; Sector
		mov dl, [_CurrentDisk]
		
		mov al, 0x01 ; Count
		mov ah, 0x03
		int 13h
		jc DiskWriteError
		
		cmp al, 0x01
		jnz DiskWriteError
		ret
	
	.end:
	popa
	ret

_BRFS_WriteSector:
	; BH,BL: Sector
	pusha
	; Adress in BH:BL
	rol bx, 8
	call LBA2CHS
	
	xor bx,bx
	mov es, bx
	mov bx, _BRFS_TWS_
	
	mov ch, [_lba_C] ; Cilindro.
	mov dh, [_lba_H] ; Cabeza.
	mov cl, [_lba_S] ; Sector
	mov dl, [_CurrentDisk]
	
	mov al, 0x01 ; Count
	mov ah, 0x03
	int 13h
	jc DiskWriteError
	
	cmp al, 0x01
	jnz DiskWriteError
	
	popa
	ret