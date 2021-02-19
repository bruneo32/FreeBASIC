str_cmds:
	db ' Type a command followed by "?" for more help.    Ej.:  COLOR ?',13
	db 13
	db ' Commands about BASIC:',13
	db '  > LIST, LOAD, NEW, RUN, SAVE',13
	db 13
	db ' Commands about system:',13
	db '  > CDT, CLS, COLOR, HELP, MEM, OFF, PRE, PRG, SYS, VER',13
	db 13
	db ' Commands about filesystem:',13
	db '  > CAT, CD, DEL, DELD, MD, REN, REND, RTX, WTX',13
	db 13
	db ' Commands about filesystem (advanced):',13
	db '  > COPY, COPYD, INF, INFD, MOV, MOVD, STR, STRD',13
	db 13
	db ' Commands about disks:',13
	db '  > DSK, DSKDAT, FORMAT, LD'
	
	db 0
	
str_cmd_HELP:
	db 'HELP',0
cmd_HELP:
	; Verificacion rutinaria
	cmp bh, byte 0 ; Si el comando introducido no era OFF, terminar
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+5]
	jnz .comm
	call __SECRETGAME__
	call ConsoleClear
	xor bx, bx
	jmp .cmdEnd
	
	.comm:
	
	call PrintLn
	mov si, str_cmds
	call PrintStringLn
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_CAT:
	db 'CAT',0
str_cmdh_CAT:
	db ' (?) Watch a list with all the items in the current directory.',0
cmd_CAT:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_CAT
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	
	jmp .starti
	
	;vars
	.dirstr:
		db '[D]',0
	
	.starti:
	call _BRFS_ReadSectorCD
	jc .cmdEnd
	
	cmp byte [__unreadable_disk], 0x00
	jnz .unreadable
	
	mov bx, 0x0001
	call MovCursorRel
	
	mov ah,0x0e
	mov al, byte '['
	int 10h
	mov si, _CurrentLabel
	call PrintString
	mov ah,0x0e
	mov al, byte ']'
	int 10h
	
	call PrintLn
	call PrintLn
	mov bx, 0x0001
	call MovCursorRel
	.starti2:
	mov cx, 0x000a ; Each 10 elements printed, __MORE__
	mov si, _BRFS_TRS_
	.loop:
		cmp cx, byte 0
		jnz .exitgc
		
			push si
			call __more
			pop si
			cmp bl, byte 0
			jnz .cmdEndG
			
			mov cx, 0x10 ; Reset, after  __more
			
			mov bx, 0x0001
			call MovCursorRel
		
		.exitgc:
		
		cmp si, _BRFS_TRS_+510
		jae .exitLoop ; Hay que leer más sectores
		
		mov bh, [si]
		cmp bh, 0x1c ; Fichero
		jz .salto
		mov bh, [si]
		cmp bh, 0x1d ; Directorio
		jz .salto0
		
		jmp .esc
		
		.salto0:
			push si
			push dx
			
			call GetCursorPos
			mov dh, [_CursorRow]
			mov dl, 0x20
			call SetCursorPos
			
			mov si, .dirstr
			call PrintString
			
			pop dx
			pop si
		.salto:
			add si,2
			call PrintLn
			mov bx, 0x0001
			call MovCursorRel
			dec cx ; Para contar elementos
			jmp .next
		
		.esc:
		; Ignorar hasta encontrar el siguiente
		mov al, [si]
		cmp al, 32
		jb .next
		
		call GetCursorPos
		mov bh, 0x1e
		mov bl, [_CursorCol]
		cmp bl, bh
		jb .esc2
		
		mov bh, 0x1f
		cmp bl, bh
		jae .next
		
		mov ah, 0x0e
		mov al, '|'
		xor bx, bx
		int 10h
		jmp .next
		
		.esc2:
		mov ah, 0x0e
		xor bx, bx ; PAGE
		int 10h
		
		.next:
		inc si
		jmp .loop
	.exitLoop:
	mov si, _BRFS_TRS_+510
	xor bh, bh
	cmp bh, [si]
	jnz .leermas
	cmp bh, [si+1]
	jnz .leermas
	
	jmp .cmdEndG
	
	.leermas:
	mov bh, [si]
	mov bl, [si+1]
	call _BRFS_ReadSector
	jmp .starti2
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.unreadable:
	mov si, _str_cc_unreadable
	call PrintStringLn
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_CD:
	db 'CD',0
str_cmdh_CD:
	db ' (?) Change the current system path. See: CAT.',0
cmd_CD:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+3]
	jnz .comm
	mov si, str_cmdh_CD
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	
	mov bh, byte 0
	cmp bh, [_InputBuffer+3]
	jz .cmdEnd
	mov bh, 13 ; .cmd files
	cmp bh, [_InputBuffer+3]
	jz .cmdEnd
	
	cmp byte [__unreadable_disk], 0x00
	jnz .unreadable
	
	call _BRFS_ReadSectorCD
	jc .cmdEnd
	
	; Buscar si existe
	mov bl, 0x1d
	mov si, _InputBuffer+3
	call _BRFS_GetElementFromDir
	jc .cmdEndB ; No existe
	
	mov [_CD], dh
	mov [_CD+1], dl
	
	jmp .cmdEndG
	
	jmp .cmdEndG
	.cmdEndB:
	mov si, _str_cc_unkPath
	call PrintStringLn
	ret
	.unreadable:
	mov si, _str_cc_unreadable
	call PrintStringLn
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_CDT:
	db 'CDT',0
str_cmdh_CDT:
	db ' (?) Watch the Current Date and Time. ISO 8601 standard.',13
	db 13
	db ' FORMAT    : YYYY-MM-DD   HH:MM',13
	db ' Example   : 2021-02-16   11:15',13
	db ' Means:',13
	db ' > Year    : 2021',13
	db ' > Month   : 02 (February)',13
	db ' > Day     : 16',13
	db ' ',175,' Hours   : 11',13
	db ' ',175,' Minutes : 15'
	db 0
cmd_CDT:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_CDT
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	
	call PrintLn
	
	mov bx, 0x0003
	call MovCursorRel
	
	call _sys_get_date
	mov si, _sys_date
	call PrintString
	
	mov bx, 0x0003
	call MovCursorRel
	
	call _sys_get_time
	mov si, _sys_time
	call PrintString
	
	
	call PrintLn
	
	jmp .cmdEndG
	.cmdEndB:
	mov bx, word 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_CLS:
	db 'CLS',0
str_cmdh_CLS:
	db ' (?) Clear the screen rect.',0
cmd_CLS:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_CLS
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	
	call ConsoleClear
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_COLOR:
	db 'COLOR',0
str_cmdh_COLOR:
	db ' (?) Set a color attribute for the console output.',13
	db 13
	db '  0 = Black       8 = Gray',13
	db '  1 = Blue        9 = Light Blue',13
	db '  2 = Green       A = Light Green',13
	db '  3 = Aqua        B = Light Aqua',13
	db '  4 = Red         C = Light Red',13
	db '  5 = Purple      D = Light Purple',13
	db '  6 = Yellow      E = Light Yellow',13
	db '  7 = White       F = Bright White',13
	db 13
	db '  > First digit  : Background color',13
	db '  > Second digit : Foreground color',13
	db '  Example:  COLOR 1F, produces bright white foreground over a blue background.',13
	db '  *Note: The background has 8 colors and the foreground 16 (F); if you try a background color above 7, it results on a blinking text.'
	db 0
cmd_COLOR:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+6]
	jnz .comm
	mov si, str_cmdh_COLOR
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	
	mov bh, byte [_InputBuffer+6]
	mov bl, byte [_InputBuffer+7]
	
	cmp bh, byte 0
	jz .cmdEndB
	cmp bl, byte 0
	jz .cmdEndB
	cmp bl, byte '0'
	jl .cmdEndB
	cmp bl, byte 'z'
	jg .cmdEndB
	
	cmp bh, byte 'a'
	jl .nextm3
	sub bh, 32
	.nextm3:
	cmp bl, byte 'a'
	jl .nextm2
	sub bl, 32
	
	.nextm2:
	cmp bh, byte '9'
	jle .nextm1
	cmp bh, byte 'A'
	jl .cmdEndB
	.nextm1:
	cmp bl, byte '9'
	jle .next0
	cmp bl, byte 'A'
	jl .cmdEndB
	
	
	.next0:
	sub bh, byte '0'
	sub bl, byte '0'
	
	.next:
	cmp bh, 0x0a
	jl .next11
	sub bh, 0x07
	.next11:
	cmp bl, 0x0a
	jl .next2
	sub bl, 0x07
	
	.next2:
	shl bh, 4
	or bh, bl
	
	mov byte [COLOR], bh
	
	call _FillColor
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_DSK:
	db 'DSK',0
str_cmdh_DSK:
	db ' (?) Jump to the root directory of the disk specified. Example: DSK 0, DSK 1, DSK 2, ...',13
	db '     Use "DSK ." to jmp to the system disk.',0
cmd_DSK:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_DSK
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	mov bl, byte [_InputBuffer+4]
	
	cmp bl, byte '.'
	jnz .si
	mov bl, byte [BOOT_DRIVE]
	jmp .su
	
	.si:
	cmp bl, byte 'A'
	jb .floppy
	
	add bl, 63 ; Force x80
	jmp .su
	
	.floppy:
	sub bl, byte '0'
	
	.su:
	mov byte [_CurrentDisk], bl
	mov dl, bl
	call __GetDriveParameters
	mov byte [_CD], 0x00
	mov byte [_CD+1], 0x01
	
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_DSKDAT:
	db 'DSKDAT',0
str_cmdh_DSKDAT:
	db ' (?) Watch information about the current disk.',0
cmd_DSKDAT:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+7]
	jnz .comm
	mov si, str_cmdh_DSKDAT
	call PrintStringLn
	xor bx, bx
	ret
	
	.str_diskid:
		db '  Disk ID: ',0
	.str_SectorsPerTrack:
		db '   > Sectors Per Track    : $',0
	.str_NumHeads:
		db '   > Number of Heads      : $',0
	.str_NumCillinders:
		db '   > Number of Cillinders : $',0
	.str_label:
		db '  LABEL: ',0
	.str_Subformat:
		db '  BRFS Subformat          : BRFS-16a',13
		db '   > Index labeling       : ASCII',13
		db '   > Pointer size         : 16 bit',13
		db '   > Attribute size       : $0'
		db 0

	.comm:
	
	call PrintLn
	
	mov si, .str_diskid
	call PrintString
	mov al, byte [_CurrentDisk]
	cmp al, byte 0x80
	jb .si
	sub al, byte 63
	jmp .prr
	.si:
	add al, byte '0'
	.prr:
	mov ah,0x0e
	int 10h
	call PrintLn
	
	mov si, .str_SectorsPerTrack
	call PrintString
	mov al, byte [_SectorsPerTrack]
	add al, byte '0'
	mov ah,0x0e
	int 10h
	call PrintLn
	
	mov si, .str_NumHeads
	call PrintString
	mov al, byte [_NumHeads]
	add al, byte '0'
	mov ah,0x0e
	int 10h
	call PrintLn
	
	mov si, .str_NumCillinders
	call PrintString
	mov al, byte [_NumCillinders]
	add al, byte '0'
	mov ah,0x0e
	int 10h
	call PrintLn
	call PrintLn
	
	mov si, .str_label
	call PrintString
	mov si, _CurrentLabel
	call PrintStringLn
	
	cmp byte [__unreadable_disk], 0x00
	jnz .unreadable
	
	call PrintLn
	mov si, .str_Subformat
	call PrintStringLn
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.unreadable:
	call PrintLn
	mov bx, 0x0002
	call MovCursorRel
	mov si, _str_cc_unreadable
	call PrintStringLn
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_EMP:
	db 'EMP',0
str_cmdh_EMP:
	db ' (?) Does literally nothing. xD',0
cmd_EMP:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_EMP
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	
	
	; ABSOLUTAMENTE NADA XD
	
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_FORMAT:
	db 'FORMAT',0
str_cmdh_FORMAT:
	db ' (?) Erase all the disk data of a disk, and format the disk as BRFS-32a.',0
cmd_FORMAT:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+7]
	jnz .comm
	mov si, str_cmdh_FORMAT
	call PrintStringLn
	xor bx, bx
	ret
	
	.str_booterr:
		db 'You cannot format the system disk. If you want to restore the default system, try reinstalling it on this disk.',0
	.str_label:
		db 'LABEL? ',0
	
	.comm:
	
	mov bl, byte [_InputBuffer+7]
	
	cmp bl, byte 0
	jz .cmdEndB
	
	cmp bl, byte 'A'
	jl .floppy
	
	add bl, 63 ; Force x80
	jmp .prr
	
	.floppy:
	sub bl, byte '0'
	.prr:
	cmp bl, byte [BOOT_DRIVE]
	jnz .ok
	
	mov si, .str_booterr
	call PrintStringLn
	jmp .cmdEndG
	
	.ok:
	push bx
	call __ensure
	cmp bl, byte 0
	jnz .cmdEndB
	
	; xor bx,bx
	; call _BRFS_ReadSector
	
	; pop dx
	; xor bx,bx
	; mov es,bx
	; mov bx, _BRFS_TRS_
	; xor cx,cx
	; xor dh,dh
	; mov al, 0x01
	; mov ah, 0x03
	; int 13h
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_INF:
	db 'INF',0
str_cmdh_INF:
	db ' (?) Watch information about a file. Use INFD for directories.',0
cmd_INF:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_INF
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	
	mov bl, byte [_InputBuffer+4]
	cmp bl, byte 0
	jz .cmdEnd
	
	mov bl, 0x1c
	mov si, _InputBuffer+4
	call cmd_INF_holder
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_INFD:
	db 'INFD',0
str_cmdh_INFD:
	db ' (?) Watch information about a directory. Use INF for files.',0
cmd_INFD:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+5]
	jnz .comm
	mov si, str_cmdh_INFD
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	
	mov bl, byte [_InputBuffer+5]
	cmp bl, byte 0
	jz .cmdEnd
	
	mov bl, 0x1d
	mov si, _InputBuffer+5
	call cmd_INF_holder
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

cmd_INF_holder:
	jmp .comm
	
	.str_size:
		db '  Size      :  $',0
	.str_lba:
		db '  First LBA :  $',0
	.str_sectors:
		db ' sector(s) (1 sector = 512 bytes)',0
	
	.sizecount:
		times 4 db 0
		db 0
	.lbahex:
		times 4 db 0
		db 0
	
	.TYPEE: db 0
	
	.comm:
	cmp byte [__unreadable_disk], 0x00
	jnz .unreadable
	
	mov byte [.TYPEE], bl
	push si
	
	; Buscar si existe
	call _BRFS_ReadSectorCD
	jc .cmdEnd
	mov bl, byte [.TYPEE]
	pop si
	call _BRFS_GetElementFromDir
	jc .cmdEndB ; No existe
	
	
	; LBA to HEX
		xor bx, bx
		mov bl, dh
		shl bx, 4
		shr bl, 4
		add bh, '0' ; Convertir a ASCII
		add bl, '0' ; Convertir a ASCII
		cmp bh, '9'
		jbe .ibh1
		add bh, 7 ; Hasta la 'A'
.ibh1:	cmp bl, '9'
		jbe .ibl1
		add bl, 7 ; Hasta la 'A'
.ibl1:	mov [.lbahex], bh
		mov [.lbahex+1], bl
		
		xor bx, bx
		mov bl, dl
		shl bx, 4
		shr bl, 4
		add bh, '0' ; Convertir a ASCII
		add bl, '0' ; Convertir a ASCII
		cmp bh, '9'
		jbe .ibh2
		add bh, 7 ; Hasta la 'A'
.ibh2:	cmp bl, '9'
		jbe .ibl2
		add bl, 7 ; Hasta la 'A'
.ibl2:	mov [.lbahex+2], bh
		mov [.lbahex+3], bl
	
	
	; SIZE
	mov cx, word 1
	push cx
	
	.loop:
		mov bh, dh
		mov bl, dl
		call _BRFS_ReadSector
		jc .cmdEndB
		
		mov si, _BRFS_TRS_+510
		cmp [si], byte 0
		jnz .next
		cmp [si+1], byte 0
		jnz .next
		
		jmp .exitLoop
		
		.next:
		pop cx
		inc cx
		push cx
		
		mov dh, [si]
		mov dl, [si+1]
		jmp .loop
	.exitLoop:
	pop cx
		xor bx, bx
		mov bl, ch
		shl bx, 4
		shr bl, 4
		add bh, '0' ; Convertir a ASCII
		add bl, '0' ; Convertir a ASCII
		cmp bh, '9'
		jbe .ibh3
		add bh, 7 ; Hasta la 'A'
.ibh3:	cmp bl, '9'
		jbe .ibl3
		add bl, 7 ; Hasta la 'A'
.ibl3:	mov [.sizecount], bh
		mov [.sizecount+1], bl
		
		xor bx, bx
		mov bl, cl
		shl bx, 4
		shr bl, 4
		add bh, '0' ; Convertir a ASCII
		add bl, '0' ; Convertir a ASCII
		cmp bh, '9'
		jbe .ibh4
		add bh, 7 ; Hasta la 'A'
.ibh4:	cmp bl, '9'
		jbe .ibl4
		add bl, 7 ; Hasta la 'A'
.ibl4:	mov [.sizecount+2], bh
		mov [.sizecount+3], bl
	
	
	; Display
	call PrintLn
	
	mov si, .str_size
	call PrintString
	mov si, .sizecount
	call PrintString
	mov si, .str_sectors
	call PrintStringLn
	
	mov si, .str_lba
	call PrintString
	mov si, .lbahex
	call PrintStringLn
	
	jmp .cmdEndG
	
	.unreadable:
	mov si, _str_cc_unreadable
	call PrintStringLn
	jmp .cmdEndG
	.cmdEndB:
	mov si, _str_cc_unkPath
	call PrintStringLn
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_LD:
	db 'LD',0
str_cmdh_LD:
	db ' (?) Watch the number of disks accessibles by the system. Use DSK to change the current disk.',0
cmd_LD:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+3]
	jnz .comm
	mov si, str_cmdh_LD
	call PrintStringLn
	xor bx, bx
	ret
	
	.str_blist:
		db '  Boot Disk: ',0
	.str_diskettes:
		db '  Available disks: ',0
	.str_list:
		db '   > Disk ',0
	
	.comm:
	
	call PrintLn
	mov si, .str_blist
	call PrintString
	mov al, byte [BOOT_DRIVE]
	add al, byte '0'
	mov ah, 0x0e
	int 10h
	
	call PrintLn
	
	mov si, .str_diskettes
	call PrintString
	
	mov cl, al
	xor al, al
	.cdsk:
		cmp al, 0xFF
		jz .exitCdsk
		
		
		push ax
		
		clc
		xor ax, ax ; Reset
		int 13h
		xor bx, bx
		mov es, bx
		mov bx, _BRFS_TRS_
		pop ax
		push ax
		mov dl, al
		mov al, 0x01 ; Sectors to read
		xor ch,ch ; Cilindro.
		xor dh,dh ; Cabeza.
		mov cl, 0x01 ; Sector
		mov ah, 0x02 ; Read Disk int 13h/02h
		int 13h
		jc .next ; No se puede leer = No existe
		pop ax
		
		push ax
		call PrintLn
		mov si, .str_list
		call PrintString
		cmp al, byte 0x80 ; Hard Drive
		jb .floppy
		sub al, 63
		; Force to 'A'
		jmp .prr
		.floppy:
		add al, byte '0'
		.prr:
		mov ah, 0x0e
		int 10h
		
		.next:
		pop ax
		inc al
		jmp .cdsk
	.exitCdsk:
	
	call PrintLn
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_LIST:
	db 'LIST',0
str_cmdh_LIST:
	db ' (?) List the program in memory. You can use special arguments.',13
	db '  Examples:',13
	db '   > LIST',13
	db '   > LIST 10',13
	db '   > LIST 20-50',13
	db '   > LIST -31',13
	db '   > LIST 80-'
	db 0
cmd_LIST:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+5]
	jnz .comm
	mov si, str_cmdh_LIST
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	
	mov si, _InputBuffer+5
	call MIT_LIST
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_LOAD:
	db 'LOAD',0
str_cmdh_LOAD:
	db ' (?) Load a BASIC program, overwritting the current program.',0
cmd_LOAD:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+5]
	jnz .comm
	mov si, str_cmdh_RTX
	call PrintStringLn
	xor bx, bx
	ret
	
	; vars
	._c:	dw 0
	
	.comm:
	
	mov bh, byte 0
	cmp bh, [_InputBuffer+5]
	jz .cmdEnd
	mov bh, 13 ; .cmd files
	cmp bh, [_InputBuffer+5]
	jz .cmdEnd
	
	call _BRFS_ReadSectorCD
	jc .cmdEndB
	
	; Buscar si existe
	mov bl, 0x1c ; Fichero
	mov si, _InputBuffer+5
	call _BRFS_GetElementFromDir
	jc .cmdEndB ; No existe
	; Adress in DX
	mov [._c], dh
	mov [._c+1], dl
	
	mov bh, dh
	mov bl, dl
	call _BRFS_ReadSector
	jc .cmdEndB
	
	pusha
	call cmd_NEW.preloopi
	popa
	
	.starti2:
	mov si, _BRFS_TRS_
	.loop:
		cmp si, _BRFS_TRS_+510
		jz .exitLoop
		
		mov bh, [si]
		mov di, word [BasicProgramCounter]
		mov [di], bh
		
		.next:
		inc si
		inc word [BasicProgramCounter]
		jmp .loop
	.exitLoop:
	; Verificar si hay más
	xor bh, bh
	cmp bh, [si]
	jnz .msg_leermas
	cmp bh, [si+1]
	jnz .msg_leermas
	
	jmp .cmdEndG
	
	
	.msg_leermas:
	xor bh, bh
	cmp bh, [si]
	jnz .leermas ; No es 0x0001
	inc bh
	cmp bh, [si+1]
	jnz .leermas
	
	; Leermas1
	mov bh, [._c]
	mov bl, [._c+1]
	inc bx
	mov [._c], bh
	mov [._c+1], bl
	call _BRFS_ReadSector
	jmp .starti2
	
	.leermas:
	mov bh, [si]
	mov bl, [si+1]
	call _BRFS_ReadSector
	jmp .starti2
	
	.cmdEndB:
	mov si, _str_cc_unkPath
	call PrintString
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_MEM:
	db 'MEM',0
str_cmdh_MEM:
	db ' (?) Reports the number of contiguous 1K memory blocks in the system (up to 640K).',0
cmd_MEM:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_MEM
	call PrintStringLn
	xor bx, bx
	ret
	
	.str1:
		db '   Memory size, 1K blocks (up to 640K)   :  0x',0
	.memsize:
		db 0,0,0,0
		db 0
	.str2:
		db '   Accessibles by the system             :  0x80 =0x40+0x40 [-2 bytes]',13
		db 13
		db '   Lower memory size   (0000 - 7E00)     :  0x20',13
		db '   System size         (7E00 - AA00)     :  0x0B',13
		db '   BASIC program space (AA00 - 10000)    :  0x15',13
		db '   Programs space      (10000 - 1FFFF)   :  0x40 [-2 bytes]',0
	
	
	.comm:
	
	pusha
	
	call PrintLn
	
	mov si, .str1
	call PrintString
	
	int 12h ; Return mem size in AX
	
		xor bx, bx
		mov bl, ah
		shl bx, 4
		shr bl, 4
		add bh, '0' ; Convertir a ASCII
		add bl, '0' ; Convertir a ASCII
		cmp bh, '9'
		jbe .ibh1
		add bh, 7 ; Hasta la 'A'
.ibh1:	cmp bl, '9'
		jbe .ibl1
		add bl, 7 ; Hasta la 'A'
.ibl1:	mov [.memsize], bh
		mov [.memsize+1], bl
	
		xor bx, bx
		mov bl, al
		shl bx, 4
		shr bl, 4
		add bh, '0' ; Convertir a ASCII
		add bl, '0' ; Convertir a ASCII
		cmp bh, '9'
		jbe .ibh2
		add bh, 7 ; Hasta la 'A'
.ibh2:	cmp bl, '9'
		jbe .ibl2
		add bl, 7 ; Hasta la 'A'
.ibl2:	mov [.memsize+2], bh
		mov [.memsize+3], bl
	
	mov si, .memsize
	call PrintStringLn
	
	mov si, .str2
	call PrintStringLn
	
	popa
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_NEW:
	db 'NEW',0
str_cmdh_NEW:
	db ' (?) Clear the program in memory. Use "NEW +" to avoid prompting.',0
cmd_NEW:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_NEW
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	xor bx, bx
	
	mov bh, byte '+' ; Sin preguntar
	cmp bh, [_InputBuffer+4]
	jz .preloopi
	
	call __ensure
	cmp bl, byte 0
	jnz .cmdEnd
	
	.preloopi:
	mov si, BasicSpace
	.loopi:
		; Limitar
		mov bx, 0xce00
		cmp di, bx ; BasicSpace Limit
		jae .exitLoop
		
		mov bh, byte 0
		cmp bh, [si]
		jz .exitLoop ; Si encuentra un NUL significa que ya ha terminado
		
		mov [si], bh
		
		inc si
		jmp .loopi
	.exitLoop:
	mov [BasicProgramCounter], word BasicSpace
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_OFF:
	db 'OFF',0
str_cmdh_OFF:
	db ' (?) Turns off the computer. Use "OFF +" to avoid prompting.',13
	db '     Type "OFF %" to reboot the system. Depending on your BIOS, you may have to perform some actions to reboot.'
	db 0
cmd_OFF:
	; Verificacion rutinaria
	cmp bh, byte 0 ; Si el comando introducido no era OFF, terminar
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_OFF
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	
	mov bh, byte '+' ; Sin preguntar
	cmp bh, [_InputBuffer+4]
	jz .exitgc
	
	mov bh, byte '%' ; Sin preguntar
	cmp bh, [_InputBuffer+4]
	jnz .offi
	
	; Reboot
	call __ensure
	cmp bl, byte 0
	jnz .cmdEndG
	int 19h
	
	.offi:
	mov si, _str_cc_OFF
	call PrintStringLn
	
	.gc:
		mov ah, 01h
		int 16h
		jz .gc
		
		mov ah, 00h
		int 16h
		
		cmp al, 13
		jz .exitgc
		
		jmp .cmdEndG
	.exitgc:
	
	mov si, _str_cc_OFF2
	call PrintString
	
	mov cx, 0x002d ; 3 SECONDS
	mov dx, 0xc6c0
	call _sys_wait
	
	call _sys_shutdown
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_PRE:
	db 'PRE',0
str_cmdh_PRE:
	db ' (?) Change the prefix of the command line (default: "# "). Maximum 6 characters.',0
cmd_PRE:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_PRE
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	
	; MAXIMO 8
	mov si, _InputBuffer+4
	mov di, str_pretext
	.loop:
		cmp si, _InputBuffer+4+6 ; Ojo con el maximo
		ja .exitLoop
		
		mov bx, [si]
		mov [di], bx
		
		inc si
		inc di
		
		jmp .loop
	.exitLoop:
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_PRG:
	db 'PRG',0
str_cmdh_PRG:
	db ' (?) Load a compiled program file (*.prg) into 0x10000, and the runs it.',0
cmd_PRG:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_PRG
	call PrintStringLn
	xor bx, bx
	ret
	
	; vars
	._c:	dw 0
	
	.comm:
	
	mov bh, byte 0
	cmp bh, [_InputBuffer+4]
	jz .cmdEnd
	mov bh, 13 ; .cmd files
	cmp bh, [_InputBuffer+4]
	jz .cmdEnd
	
	call _BRFS_ReadSectorCD
	jc .cmdEndB
	
	; Buscar si existe
	mov bl, 0x1c ; Fichero
	mov si, _InputBuffer+4
	call _BRFS_GetElementFromDir
	jc .cmdEndB ; No existe
	; Adress in DX
	mov [._c], dh
	mov [._c+1], dl
	
	mov bh, dh
	mov bl, dl
	call _BRFS_ReadSector
	jc .cmdEndB
	
	mov di, 0x0000
	.starti2:
	mov si, _BRFS_TRS_
	.loop:
		cmp si, _BRFS_TRS_+510
		jz .exitLoop
		
		mov al, byte [si]
		push si
		mov si, di
		call ExtendedStore
		pop si
		
		.next:
		inc si
		inc di
		jmp .loop
	.exitLoop:
	; Verificar si hay más
	
	xor bh, bh
	cmp bh, [si]
	jnz .msg_leermas
	cmp bh, [si+1]
	jnz .msg_leermas
	
	; Transfer control
	mov bx, 0xFFFF
	mov di, 0x0001
	mov es, bx
	;call 0:
	
	
	
	jmp .cmdEndG
	
	
	.msg_leermas:
	xor bh, bh
	cmp bh, [si]
	jnz .leermas ; No es 0x0001
	inc bh
	cmp bh, [si+1]
	jnz .leermas
	
	; Leermas1
	mov bh, [._c]
	mov bl, [._c+1]
	inc bx
	mov [._c], bh
	mov [._c+1], bl
	call _BRFS_ReadSector
	jmp .starti2
	
	.leermas:
	mov bh, [si]
	mov bl, [si+1]
	call _BRFS_ReadSector
	jmp .starti2
	
	.cmdEndB:
	mov si, _str_cc_unkPath
	call PrintStringLn
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_RTX:
	db 'RTX',0
str_cmdh_RTX:
	db ' (?) Read a text file and print it on screen.',0
cmd_RTX:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_RTX
	call PrintStringLn
	xor bx, bx
	ret
	
	; vars
	._c:	dw 0
	
	.comm:
	
	mov bh, byte 0
	cmp bh, [_InputBuffer+4]
	jz .cmdEnd
	mov bh, 13 ; .cmd files
	cmp bh, [_InputBuffer+4]
	jz .cmdEnd
	
	cmp byte [__unreadable_disk], 0x00
	jnz .unreadable
	
	call _BRFS_ReadSectorCD
	jc .cmdEndB
	
	; Buscar si existe
	mov bl, 0x1c ; Fichero
	mov si, _InputBuffer+4
	call _BRFS_GetElementFromDir
	jc .cmdEndB ; No existe
	; Adress in DX
	mov [._c], dh
	mov [._c+1], dl
	
	mov bh, dh
	mov bl, dl
	call _BRFS_ReadSector
	jc .cmdEndB
	
	.starti2:
	mov si, _BRFS_TRS_
	.loop:
		cmp si, _BRFS_TRS_+510
		jz .exitLoop
		
		; Ignorar hasta encontrar el siguiente
		mov al, [si]
		cmp al, 13 ; ENTER - CR
		jnz .esc
		call PrintLn
		jmp .next
		
		.esc:
		cmp al, 32 ; SPACE
		jb .next
		
		mov ah, 0x0e
		xor bx, bx ; PAGE
		int 10h
		
		.next:
		inc si
		jmp .loop
	.exitLoop:
	; Verificar si hay más
	
	xor bh, bh
	cmp bh, [si]
	jnz .msg_leermas
	cmp bh, [si+1]
	jnz .msg_leermas
	
	jmp .cmdEndG
	
	
	.msg_leermas:
	push si
	call __more
	pop si
	cmp bl, byte 0
	jnz .cmdEndG
	
	xor bh, bh
	cmp bh, [si]
	jnz .leermas ; No es 0x0001
	inc bh
	cmp bh, [si+1]
	jnz .leermas
	
	; Leermas1
	mov bh, [._c]
	mov bl, [._c+1]
	inc bx
	mov [._c], bh
	mov [._c+1], bl
	call _BRFS_ReadSector
	jmp .starti2
	
	.leermas:
	mov bh, [si]
	mov bl, [si+1]
	call _BRFS_ReadSector
	jmp .starti2
	
	.cmdEndB:
	mov si, _str_cc_unkPath
	call PrintString
	.unreadable:
	mov si, _str_cc_unreadable
	call PrintStringLn
	.cmdEndG:
	call PrintLn
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_RUN:
	db 'RUN',0
str_cmdh_RUN:
	db ' (?) Run the program in memory.',0
cmd_RUN:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_RUN
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	
	mov si, BasicSpace
	call MIT_INTERPRET
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_VER:
	db 'VER',0
str_cmdh_VER:
	db ' (?) Watch information about the current version of FreeBASIC.',0
cmd_VER:
	; Verificacion rutinaria
	cmp bh, byte 0 ; Si el comando introducido no era OFF, terminar
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_VER
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	
	call PrintLn
	mov si, _str_cc_version
	call PrintStringLn
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_WTX:
	db 'WTX',0
str_cmdh_WTX:
	db ' (?) Write from the console prompt to a specified text file (Argument 1).',13
	db '     Ex.: WTX example.txt',0
cmd_WTX:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_WTX
	call PrintStringLn
	xor bx, bx
	ret
	
	; vars
	._c:	dw 0
	
	.comm:
	
	mov bh, byte 0
	cmp bh, [_InputBuffer+4]
	jz .cmdEnd
	mov bh, 13 ; .cmd files
	cmp bh, [_InputBuffer+4]
	jz .cmdEnd
	
	call _BRFS_ReadSectorCD
	jc .cmdEndB
	
	; Buscar si existe
	mov bl, 0x1c ; Fichero
	mov si, _InputBuffer+4
	call _BRFS_GetElementFromDir
	jnc .cmdEndB ; Ya existe
	
	
	.starti2:
	mov si, _BRFS_TRS_
	.loop:
		cmp si, _BRFS_TRS_+510
		jz .exitLoop
		
		
		
		.next:
		inc si
		jmp .loop
	.exitLoop:
	jmp .cmdEndG
	
	.cmdEndB:
	mov si, _str_cc_knownPath
	call PrintStringLn
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

__ensure:
	mov si, _str__ensure
	call PrintString
	
	call GetChar
	
	cmp al, 13
	jz .exitgc
	
	mov bl, 0x01 ; Ha pulsado otra tecla
	jmp .end
	
	.exitgc:
	call PrintLn
	mov si, _str__OK
	call PrintString
	
	xor bl, bl ; GG
	.end:
	call PrintLn
	ret
__more:
	call GetCursorPos
	mov dh, [_CursorRow]
	mov dl, [_CursorCol]
	push dx
	
	call PrintLn
	mov si, _str__MORE
	call PrintString
	
	call GetChar
	cmp al, 13
	jz .exitgc
	
	pop dx ; Ojito con el stack
	mov bl, 0x01 ; Ha pulsado otra tecla
	jmp .end
	
	.exitgc:
	
	; Mini Clear
	call GetCursorPos
	mov dh, byte [_CursorRow]
	mov dl, byte [SafeRect+1]
	call SetCursorPos
	mov ah, 0x09
	mov al, ' '
	
	xor cx,cx
	xor bh,bh
	mov bl, byte [SafeRect+3]
	add cx, bx
	xor bh,bh
	mov bl, byte [SafeRect+1]
	sub cx, bx
	
	xor bh, bh
	mov bl, byte [COLOR]
	int 10h
	
	pop dx
	call SetCursorPos
	
	xor bl, bl ; GG
	.end:
	ret

; Strings
_str_cc_OFF:
	db 13,'> Press ENTER to turn off the computer, or any other key to cancel.', 0
_str_cc_OFF2:
	db '> Shutting down...',0
_str_cc_unkPath:
	db 'Unknown file or path.',0
_str_cc_knownPath:
	db 'The file or path already exists.',0
_str_cc_Unk:
	db ' -- Este comando no esta terminado xD --',0
_str_cc_version:
	db ' FreeBASIC 0.5.1        published under GPL 3 license.',13
	db 13
	db ' > System               by Bruno Castro Garcia',13
	db '   version 0.5          [bruno@retronomicon.gq]',13
	db 13
	db ' > BASIC Core           by Angel Ruiz Fernandez',13
	db '   version 0.1          [aruizfernandez05@gmail.com]',13
	db 0
_str_cc_unreadable:
	db 'Unreadable disk. Use FORMAT command',0
_str_cc_unsopportedf:
	db 'Unsopported feature.',0
_str__ensure:
	db 'Sure? Press ENTER to confirm.',0
_str__OK:
	db 'Ok!',0
_str__MORE:
	db ' --- MORE ---',0