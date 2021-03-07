str_cmds:
	db ' Type a command followed by "?" for more help.    Ej.:  COLOR ?',13
	db 13
	db ' Commands about BASIC:',13
	db '  > LIST, LOAD, NEW, RUN, SAVE',13
	db 13
	db ' Commands about system:',13
	db '  > CDT, CLS, CMD, COLOR, HELP, OFF, PRE, PRG',13
	db 13
	db ' Commands about system (advanced):',13
	db '  > ARECT, FRECT, MEM, PRT, SRECT, SYS, RASM, REM, VER',13
	db 13
	db ' Commands about filesystem:',13
	db '  > CAT, CD, DEL, DELD, MD, REN, REND, RTX, WTX',13
	db 13
	db ' Commands about filesystem (advanced):',13
	db '  > COPY, COPYD, INF, INFD, MOV, MOVD, STR, STRD',13
	db 13
	db ' Commands about disks:',13
	db '  > DSK, DSKDAT, FORMAT, LD',13
	
	db 0

str_cmd_HELP:
	db 'HELP',0
cmd_HELP:
	; Verificacion rutinaria
	cmp bh, byte 0 ; Si el comando introducido no era HELP, terminar
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

str_cmd_ARECT:
	db 'ARECT',0
str_cmdh_ARECT:
	db ' (?) Set the color attribute for a rectangle of the screen, keeping the characters inside. See COLOR.',13
	db '     Max. ROW: 0x18. Max. COL: 0x4F. You can only use two-digit hexadecimal numbers (UPPERCASE).',13
	db 13
	db '     ARECT top,left,bottom,right,attribute',13
	db '   Ex:',13
	db '     > ARECT 00,00,18,4F,02',13
	db '     > ARECT 03,05,15,49,33',13,0
cmd_ARECT:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+6]
	jnz .comm
	mov si, str_cmdh_ARECT
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	
	mov al, byte 0
	call cmd_RECT_holder
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_FRECT:
	db 'FRECT',0
str_cmdh_FRECT:
	db ' (?) Set the color attribute for a rectangle of the screen, keeping the characters inside. See ARECT.',13,0
cmd_FRECT:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+6]
	jnz .comm
	mov si, str_cmdh_FRECT
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	
	mov al, byte ' '
	call cmd_RECT_holder
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

cmd_RECT_holder:
	jmp .comm
	
	.a1:	db 0
	.a2:	db 0
	.a3:	db 0
	.a4:	db 0
	
	.hc:	db 0
	
	.comm:
	
	mov byte [.hc], al
	
	;; CHECK FOR COMMAS
	cmp byte [_InputBuffer+8], byte ','
	jnz .cmdEndB
	cmp byte [_InputBuffer+11], byte ','
	jnz .cmdEndB
	cmp byte [_InputBuffer+14], byte ','
	jnz .cmdEndB
	cmp byte [_InputBuffer+17], byte ','
	jnz .cmdEndB
	
	;	Get 		1
	mov bh, byte [_InputBuffer+6]
	mov bl, byte [_InputBuffer+7]
	;	Verify		1
	cmp bh, byte '0'
	jb .cmdEndB
	cmp bl, byte '0'
	jb .cmdEndB
	cmp bh, byte 'Z'
	ja .cmdEndB
	cmp bl, byte 'Z'
	ja .cmdEndB
	cmp bh, byte '9'
	jbe .iBH1
	cmp bh, byte 'A'
	jb .cmdEndB
	sub bh, 0x07
	.iBH1:
	cmp bl, byte '9'
	jbe .iBL1
	cmp bl, byte 'A'
	jb .cmdEndB
	sub bl, 0x07
	.iBL1:
	sub bh, byte '0'
	sub bl, byte '0'
	;	Save		1
	shl bh, 4
	or bh, bl
	mov byte [.a1], bh
	
	;	Get 		2
	mov bh, byte [_InputBuffer+9]
	mov bl, byte [_InputBuffer+10]
	;	Verify		2
	cmp bh, byte '0'
	jb .cmdEndB
	cmp bl, byte '0'
	jb .cmdEndB
	cmp bh, byte 'Z'
	ja .cmdEndB
	cmp bl, byte 'Z'
	ja .cmdEndB
	cmp bh, byte '9'
	jbe .iBH2
	cmp bh, byte 'A'
	jb .cmdEndB
	sub bh, 0x07
	.iBH2:
	cmp bl, byte '9'
	jbe .iBL2
	cmp bl, byte 'A'
	jb .cmdEndB
	sub bl, 0x07
	.iBL2:
	sub bh, byte '0'
	sub bl, byte '0'
	;	Save		2
	shl bh, 4
	or bh, bl
	mov byte [.a2], bh
	
	;	Get 		3
	mov bh, byte [_InputBuffer+12]
	mov bl, byte [_InputBuffer+13]
	;	Verify		3
	cmp bh, byte '0'
	jb .cmdEndB
	cmp bl, byte '0'
	jb .cmdEndB
	cmp bh, byte 'Z'
	ja .cmdEndB
	cmp bl, byte 'Z'
	ja .cmdEndB
	cmp bh, byte '9'
	jbe .iBH3
	cmp bh, byte 'A'
	jb .cmdEndB
	sub bh, 0x07
	.iBH3:
	cmp bl, byte '9'
	jbe .iBL3
	cmp bl, byte 'A'
	jb .cmdEndB
	sub bl, 0x07
	.iBL3:
	sub bh, byte '0'
	sub bl, byte '0'
	;	Save		3
	shl bh, 4
	or bh, bl
	mov byte [.a3], bh
	
	;	Get 		4
	mov bh, byte [_InputBuffer+15]
	mov bl, byte [_InputBuffer+16]
	;	Verify		4
	cmp bh, byte '0'
	jb .cmdEndB
	cmp bl, byte '0'
	jb .cmdEndB
	cmp bh, byte 'Z'
	ja .cmdEndB
	cmp bl, byte 'Z'
	ja .cmdEndB
	cmp bh, byte '9'
	jbe .iBH4
	cmp bh, byte 'A'
	jb .cmdEndB
	sub bh, 0x07
	.iBH4:
	cmp bl, byte '9'
	jbe .iBL4
	cmp bl, byte 'A'
	jb .cmdEndB
	sub bl, 0x07
	.iBL4:
	sub bh, byte '0'
	sub bl, byte '0'
	;	Save		4
	shl bh, 4
	or bh, bl
	mov byte [.a4], bh
	
	;	Get 		5
	mov bh, byte [_InputBuffer+18]
	mov bl, byte [_InputBuffer+19]
	;	Verify		5
	cmp bh, byte '0'
	jb .cmdEndB
	cmp bl, byte '0'
	jb .cmdEndB
	cmp bh, byte 'Z'
	ja .cmdEndB
	cmp bl, byte 'Z'
	ja .cmdEndB
	cmp bh, byte '9'
	jbe .iBH5
	cmp bh, byte 'A'
	jb .cmdEndB
	sub bh, 0x07
	.iBH5:
	cmp bl, byte '9'
	jbe .iBL5
	cmp bl, byte 'A'
	jb .cmdEndB
	sub bl, 0x07
	.iBL5:
	sub bh, byte '0'
	sub bl, byte '0'
	;	Save		5
	shl bh, 4
	or bh, bl
	
	mov ch, byte [.a1]
	mov cl, byte [.a2]
	mov dh, byte [.a3]
	mov dl, byte [.a4]
	mov al, byte [.hc]
	call _AttrRect
	; AL: Char (0 means same as previous).
	; BH: New color
	; CX: Top-Left
	;  - CH: Row
	;  - CL: Column
	; DX: Right-Bottom
	;  - DH: Row
	;  - DL: Column
	
	
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
	db ' (?) Watch a list with all the items in the current directory.',13,0
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
	
	mov al, byte '['
	call PrintChar
	mov si, _CurrentLabel
	call PrintString
	mov al, byte ']'
	call PrintChar
	
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
		
		mov al, '|'
		call PrintChar
		jmp .next
		
		.esc2:
		call PrintChar
		
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
	
	call PrintLn
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
	db ' (?) Change the current system path to a directory [Case sensitive]. See: CAT.',13,0
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
	db ' ',175,' Minutes : 15',13
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
	call PrintStringLn
	
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
	db ' (?) Clear the screen rect.',13,0
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
	db '  *Note: The background has 8 colors and the foreground 16 (0xF). If you try  to set a background color above 7, it results on a blinking text.',13
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

str_cmd_CMD:
	db 'CMD',0
str_cmdh_CMD:
	db ' (?) Execute a command file (*.cmd, *.tmp, ...).',13,0
cmd_CMD:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_CMD
	call PrintStringLn
	xor bx, bx
	ret
	
	; vars
	._c:	dw 0
	.resetinput:
		call _ClearInputBuffer
		mov di, _InputBuffer
		ret
		
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
	jc .cmdEnd
	
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
	jc .cmdEnd
	
	call .resetinput
	.starti2:
	mov si, _BRFS_TRS_
	.loop:
		cmp si, _BRFS_TRS_+510
		jz .exitLoop
		
		; Ignorar hasta encontrar el siguiente
		mov al, [si]
		cmp al, 13 ; ENTER - CR
		jz .exec
		cmp al, 0 ; END
		jz .exec
		
		; Verificar si cabe, si no: a chuparla
		cmp di, _InputBuffer+_InputBufferSize
		ja .next
		
		mov [di], al
		inc di
		
		jmp .next
		
		.exec:
		push si
		call _con_exec
		call .resetinput
		pop si
		
		.next:
		inc si
		jmp .loop
	.exitLoop:
	; Verificar si hay más
	mov si, _BRFS_TRS_+510
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
	
	.unreadable:
	mov si, _str_cc_unreadable
	call PrintStringLn
	jmp .cmdEndG
	.cmdEndB:
	mov si, _str_cc_unkPath
	call PrintStringLn
	.cmdEndG:
	call PrintLn
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_DSK:
	db 'DSK',0
str_cmdh_DSK:
	db ' (?) Jump to the root directory of the disk specified. Example: DSK 0, DSK 1, DSK 2, ...',13
	db '     Use "DSK ." to jmp to the system disk.',13,0
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
	db ' (?) Watch information about the current disk.',13,0
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
		db '   > Attribute size       : $0',13
		db 0

	.comm:
	
	call PrintLn
	
	mov si, .str_diskid
	call PrintString
	mov al, byte [_CurrentDisk]
	cmp al, byte 0x80
	jb .si
	sub al, byte 111
	.si:
	add al, byte '0'
	.prr:
	call PrintChar
	call PrintLn
	
	mov si, .str_SectorsPerTrack
	call PrintString
	mov al, byte [_SectorsPerTrack]
	add al, byte '0'
	call PrintChar
	call PrintLn
	
	mov si, .str_NumHeads
	call PrintString
	mov al, byte [_NumHeads]
	add al, byte '0'
	call PrintChar
	call PrintLn
	
	mov si, .str_NumCillinders
	call PrintString
	mov al, byte [_NumCillinders]
	add al, byte '0'
	call PrintChar
	mov al, byte [_NumCillinders+1]
	add al, byte '0'
	call PrintChar
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

str_cmd_FORMAT:
	db 'FORMAT',0
str_cmdh_FORMAT:
	db ' (?) Erase all the disk data of a disk, and format the disk as BRFS-16a.',13,0
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
		
	.miniwrite:
		xor bx,bx
		mov es,bx
		mov bx, _BRFS_TRS_
		xor ch,ch
		xor dh,dh
		; CH: Sector
		; DL: Drive number
		mov al, 0x01
		mov ah, 0x03
		int 13h
		jc DiskWriteError
		ret
	
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
	mov dl, bl ; Drive number for FORMAT interrupt
	call __ensure
	cmp bl, byte 0
	jnz .cmdEndB
	
	push dx
	
	call _BRFS_ClearTRS
	
	mov si, _DATA_BOOT
	mov di, _BRFS_TRS_
	mov bx, 512
	call _mem_copy
	
	mov [_BRFS_TRS_+510], byte 0x55
	mov [_BRFS_TRS_+511], byte 0xaa
	
	pop dx
	mov cl, 0x00
	call .miniwrite
	
	call _BRFS_ClearTRS
	
	mov cl, 0x01
	call .miniwrite
	
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
	db ' (?) Watch information about a file. Use INFD for directories.',13,0
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
	
	.cmdEnd:
	ret

str_cmd_INFD:
	db 'INFD',0
str_cmdh_INFD:
	db ' (?) Watch information about a directory. Use INF for files.',13,0
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
	jc .cmdEndG
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
		jc .cmdEndG
		
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
	
	call PrintLn
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
	db ' (?) Watch the number of disks accessibles by the system. Use DSK to change the current disk.',13,0
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
	cmp al, byte 0x80
	jb .number
	sub al, byte 111
	.number:
	add al, byte '0'
	call PrintChar
	
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
		call PrintChar
		
		.next:
		pop ax
		inc al
		jmp .cdsk
	.exitCdsk:
	
	call PrintLn
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
	db '   > LIST 80-',13
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
	
	call PrintLn
	
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
	db ' (?) Load a BASIC program, overwritting the current program.',13,0
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
	
	call PrintLn
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

str_cmd_MEM:
	db 'MEM',0
str_cmdh_MEM:
	db ' (?) Reports the number of contiguous 1K memory blocks in the system (up to 640K).',13,0
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
		db '   Lower memory size   (0000 - 1000)     :  0x04',13
		db '   System size         (1000 - 7C00)     :  0x1B',13
		db '   BASIC program space (7E00 - CE00)     :  0x14',13
		db '   Programs Space      (CE00 - 10000)    :  0x0C',13
		db '   Extended Space      (10000 - 1FFFF)   :  0x40 [-2 bytes]',13,0
	
	
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
	db ' (?) Clear the program in memory. Use "NEW +" to avoid prompting.',13,0
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
		mov bx, 0xda00
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
	db '     Type "OFF %" to reboot the system. Depending on your BIOS, you may have to perform some actions to reboot.',13
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
	call PrintLn
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
	
	mov cx, 0x1000 ; 1 SECOND
	call Sleep
	
	call _sys_shutdown
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	call PrintLn
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_PRE:
	db 'PRE',0
str_cmdh_PRE:
	db ' (?) Change the prefix of the command line (default: "# "). Maximum 6 characters.',13,0
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
	db ' (?) Load a compiled program file (*.prg) into 0xCE00, and the execute it.',13,0
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
	
	mov di, ProgramSpace
	.starti2:
	mov si, _BRFS_TRS_
	.loop:
		cmp si, _BRFS_TRS_+510
		jz .exitLoop
		
		mov al, byte [si]
		mov [di], al
		
		.next:
		inc si
		inc di
		jmp .loop
	.exitLoop:
	; Verificar si hay más
	mov si, _BRFS_TRS_+510
	xor bh, bh
	cmp bh, [si]
	jnz .msg_leermas
	cmp bh, [si+1]
	jnz .msg_leermas
	
	; Transfer control
	call 0:ProgramSpace
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

str_cmd_PRT:
	db 'PRT',0
str_cmdh_PRT:
	db ' (?) Print a string literal. Faster than PRINT from BASIC.',13,0
cmd_PRT:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_PRT
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	
	mov si, _InputBuffer+4
	call PrintStringLn
	
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_REM:
	db 'REM',0
str_cmdh_REM:
	db ' (?) Works as a comment for command files.',13,0
cmd_REM:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_REM
	call PrintStringLn
	xor bx, bx
	ret
	
	.comm:
	
	
	; Blank command
	
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_RTX:
	db 'RTX',0
str_cmdh_RTX:
	db ' (?) Read a text file and print it on screen.',13,0
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
	jc .cmdEnd
	
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
	jc .cmdEnd
	
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
		
		call PrintChar
		
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
	
	.unreadable:
	mov si, _str_cc_unreadable
	call PrintString
	jmp .cmdEndG
	.cmdEndB:
	mov si, _str_cc_unkPath
	call PrintString
	.cmdEndG:
	call PrintLn
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_RUN:
	db 'RUN',0
str_cmdh_RUN:
	db ' (?) Run the program in memory.',13,0
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

str_cmd_SRECT:
	db 'SRECT',0
str_cmdh_SRECT:
	db ' (?) Set the SAVE RECT of the screen.',13
	db '     Max. ROW: 0x18. Max. COL: 0x4F. You can only use two-digit hexadecimal numbers (UPPERCASE).',13
	db 13
	db '     SRECT top,left,bottom,right',13
	db '   Ex:',13
	db '     > SRECT 00,00,18,4F',13
	db '     > SRECT 03,05,15,49',13,0
cmd_SRECT:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+6]
	jnz .comm
	mov si, str_cmdh_SRECT
	call PrintStringLn
	xor bx, bx
	ret
	
	.a1:	db 0
	.a2:	db 0
	.a3:	db 0
	
	.comm:
	
	;; CHECK FOR COMMAS
	cmp byte [_InputBuffer+8], byte ','
	jnz .cmdEndB
	cmp byte [_InputBuffer+11], byte ','
	jnz .cmdEndB
	cmp byte [_InputBuffer+14], byte ','
	jnz .cmdEndB
	
	;	Get 		1
	mov bh, byte [_InputBuffer+6]
	mov bl, byte [_InputBuffer+7]
	;	Verify		1
	cmp bh, byte '0'
	jb .cmdEndB
	cmp bl, byte '0'
	jb .cmdEndB
	cmp bh, byte 'Z'
	ja .cmdEndB
	cmp bl, byte 'Z'
	ja .cmdEndB
	cmp bh, byte '9'
	jbe .iBH1
	cmp bh, byte 'A'
	jb .cmdEndB
	sub bh, 0x07
	.iBH1:
	cmp bl, byte '9'
	jbe .iBL1
	cmp bl, byte 'A'
	jb .cmdEndB
	sub bl, 0x07
	.iBL1:
	sub bh, byte '0'
	sub bl, byte '0'
	;	Save		1
	shl bh, 4
	or bh, bl
	mov byte [.a1], bh
	
	;	Get 		2
	mov bh, byte [_InputBuffer+9]
	mov bl, byte [_InputBuffer+10]
	;	Verify		2
	cmp bh, byte '0'
	jb .cmdEndB
	cmp bl, byte '0'
	jb .cmdEndB
	cmp bh, byte 'Z'
	ja .cmdEndB
	cmp bl, byte 'Z'
	ja .cmdEndB
	cmp bh, byte '9'
	jbe .iBH2
	cmp bh, byte 'A'
	jb .cmdEndB
	sub bh, 0x07
	.iBH2:
	cmp bl, byte '9'
	jbe .iBL2
	cmp bl, byte 'A'
	jb .cmdEndB
	sub bl, 0x07
	.iBL2:
	sub bh, byte '0'
	sub bl, byte '0'
	;	Save		2
	shl bh, 4
	or bh, bl
	mov byte [.a2], bh
	
	;	Get 		3
	mov bh, byte [_InputBuffer+12]
	mov bl, byte [_InputBuffer+13]
	;	Verify		3
	cmp bh, byte '0'
	jb .cmdEndB
	cmp bl, byte '0'
	jb .cmdEndB
	cmp bh, byte 'Z'
	ja .cmdEndB
	cmp bl, byte 'Z'
	ja .cmdEndB
	cmp bh, byte '9'
	jbe .iBH3
	cmp bh, byte 'A'
	jb .cmdEndB
	sub bh, 0x07
	.iBH3:
	cmp bl, byte '9'
	jbe .iBL3
	cmp bl, byte 'A'
	jb .cmdEndB
	sub bl, 0x07
	.iBL3:
	sub bh, byte '0'
	sub bl, byte '0'
	;	Save		3
	shl bh, 4
	or bh, bl
	mov byte [.a3], bh
	
	;	Get 		4
	mov bh, byte [_InputBuffer+15]
	mov bl, byte [_InputBuffer+16]
	;	Verify		4
	cmp bh, byte '0'
	jb .cmdEndB
	cmp bl, byte '0'
	jb .cmdEndB
	cmp bh, byte 'Z'
	ja .cmdEndB
	cmp bl, byte 'Z'
	ja .cmdEndB
	cmp bh, byte '9'
	jbe .iBH4
	cmp bh, byte 'A'
	jb .cmdEndB
	sub bh, 0x07
	.iBH4:
	cmp bl, byte '9'
	jbe .iBL4
	cmp bl, byte 'A'
	jb .cmdEndB
	sub bl, 0x07
	.iBL4:
	sub bh, byte '0'
	sub bl, byte '0'
	;	Save		4
	shl bh, 4
	or bh, bl
	
	mov byte [SafeRect+3], bh
	mov bh, byte [.a3]
	mov byte [SafeRect+2], bh
	mov bh, byte [.a2]
	mov byte [SafeRect+1], bh
	mov bh, byte [.a1]
	mov byte [SafeRect], bh
	
	
	jmp .cmdEndG
	.cmdEndB:
	mov bh, byte 1
	ret
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_SYS:
	db 'SYS',0
str_cmdh_SYS:
	db ' (?) Transfer the control to a specific position (4 hex-digit) of the memory. Example: SYS DA00. Only uppercase.',13,0
cmd_SYS:
	; Verificacion rutinaria
	cmp bh, byte 0
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+4]
	jnz .comm
	mov si, str_cmdh_SYS
	call PrintStringLn
	xor bx, bx
	ret
	
	
	.comm:
	
	mov bh, byte 0
	cmp bh, [_InputBuffer+4]
	jz .cmdEndG
	
	; Transfer control
	;call 0:ProgramSpace
	
	jmp .cmdEndG
	
	.cmdEndB:
	mov si, _str_cc_unkPath
	call PrintStringLn
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_VER:
	db 'VER',0
str_cmdh_VER:
	db ' (?) Watch information about the current version of FreeBASIC.',13,0
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
	db '     Ex.: WTX example.txt',13
	db '     Press CTRL+Z and hit ENTER to finish writing.',13
	db 13
	db '  *  WARNING: You cannot use backspace. Every char you type is stored and saved.',13,0
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
	._p:	db 0
	
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
	
	
	call _BRFS_GetFreeSector
	; Check error
	
	mov si, _InputBuffer+4
	mov bl, byte 0x1c
	mov di, word [_FreeSector]
	call _BRFS_CreateEntry
	
	
	mov byte [._p], 0x00
	.starti2:
	call _BRFS_ClearTWS
	mov si, _BRFS_TWS_
	.loop:
		cmp si, _BRFS_TWS_+510
		jz .exitLoop
		
		.GC:
		call GetChar
		cmp al, byte 13
		jz .enter
		cmp al, byte 8 ; Backspace
		jz .GC
		cmp al, byte 32
		jb .spChar
		
		.esc:
		call PrintChar
		
		jmp .store
		
		.enter:
		call PrintLn
		mov bl, byte 25
		cmp bl, byte [._p] ; ^Z
		jnz .store
		
		; END WRITTING
		mov bx, word [_FreeSector]
		call _BRFS_WriteSector
		call PrintLn
		jmp .cmdEndG
		
		.spChar:
		mov [si], al
		mov byte [._p], al
		mov bl, al
		
		mov al, byte '^'
		call PrintChar
		
		add bl, 65
		mov al, bl
		call PrintChar
		jmp .next
		
		.store:
		mov [si], al
		mov byte [._p], al
		.next:
		inc si
		jmp .loop
	.exitLoop:
	; Verify if the next sector is free
	mov bx, word [_FreeSector]
	inc bx
	call _BRFS_ReadSector
	cmp byte [_BRFS_TRS_], byte 0
	jnz .FF
	
	mov si, _BRFS_TWS_+510
	mov byte [si], 0x00
	mov byte [si+1], 0x01
	jmp .ww
	
	.FF:
	call _BRFS_GetFreeSector
	; Check error
	mov si, _BRFS_TWS_+510
	mov bl, byte [_FreeSector]
	mov byte [si], bl
	mov bl, byte [_FreeSector+1]
	mov byte [si+1], bl
	
	.ww:
	mov bx, word [_FreeSector]
	call _BRFS_WriteSector
	jmp .starti2
	
	.cmdEndB:
	mov si, _str_cc_knownPath
	call PrintStringLn
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

__ensure:
	pusha
	mov si, _str__ensure
	call PrintString
	
	call GetChar
	
	cmp al, 13
	jz .exitgc
	
	popa ; Ojo con el stack
	mov bl, 0x01 ; Ha pulsado otra tecla
	jmp .end
	
	.exitgc:
	call PrintLn
	mov si, _str__OK
	call PrintString
	
	popa
	xor bl, bl ; GG
	.end:
	call PrintLn
	ret
__more:
	pusha
	call GetCursorPos
	mov dh, [_CursorRow]
	mov dl, [_CursorCol]
	
	call PrintLn
	cmp byte [_IntScroll], byte 0
	jz .noscroll
	mov [_IntScroll], byte 0
	dec dh
	.noscroll:
	push dx
	
	mov si, _str__MORE
	call PrintString
	
	call GetChar
	cmp al, 13
	jz .exitgc
	
	pop dx ; Ojito con el stack
	popa
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
	
	popa
	xor bl, bl ; GG
	.end:
	ret

; Strings
_str_cc_OFF:
	db '> Press ENTER to turn off the computer, or any other key to cancel.', 0
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