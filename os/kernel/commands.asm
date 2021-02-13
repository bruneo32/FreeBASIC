str_cmds:
	db 'Type a command followed by "?" for more help.    Ej.: PRE ?',13
	db 13
	db 'Commands about BASIC:',13
	db ' > LIST, LOAD, NEW, RUN, SAVE',13
	db 13
	db 'Commands about system:',13
	db ' > CDT, CLS, COL, HELP, OFF, PRE, VER',13
	db 13
	db 'Commands about filesystem:',13
	db ' > CAT, CD, DEL, DELD, MD, REN, REND, RTX, WTX',13
	
	db 0
	
str_cmd_HELP:
	db 'HELP',0
str_cmdh_HELP:
	db ' (?) Descubriste un easter egg XD.',0
cmd_HELP:
	; Verificacion rutinaria
	cmp bh, byte 0 ; Si el comando introducido no era OFF, terminar
	jnz .cmdEnd
	
	mov bh, byte '?'
	cmp bh, [_InputBuffer+5]
	jnz .comm
	mov si, str_cmdh_HELP
	call PrintStringLn
	xor bx, bx
	jmp .cmdEnd
	
	.comm:
	
	call PrintLn
	mov si, str_cmds
	call PrintStringLn
	
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_CAT:
	db 'CAT',0
str_cmdh_CAT:
	db ' (?) Display a list with all the items in the current directory.',0
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
	jmp .cmdEnd
	
	.comm:
	jmp .starti
	
	;vars
	.dirstr:
		db '[D]',0
	
	.starti:
	call _BRFS_ReadSectorCD
	jc .cmdEnd
	
	call PrintLn
	mov ah, 0x0e
	mov al, ' '
	xor bx, bx
	mov cx, 0x10
	int 10h
	.starti2:
	mov si, _BRFS_TMS_
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
		
		cmp si, _BRFS_TMS_+510
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
			call PrintLn
			mov ah, 0x0e
			mov al, ' '
			xor bx, bx
			int 10h
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
	jmp .cmdEnd
	
	.comm:
	
	mov bh, byte 0
	cmp bh, [_InputBuffer+3]
	jz .cmdEnd
	mov bh, 13 ; .cmd files
	cmp bh, [_InputBuffer+3]
	jz .cmdEnd
	
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
	jmp .cmdEnd
	.cmdEndG:
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_CDT:
	db 'CDT',0
str_cmdh_CDT:
	db ' (?) Watch the Current Date and Time.',0
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
	jmp .cmdEnd
	
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
	
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_CLS:
	db 'CLS',0
str_cmdh_CLS:
	db ' (?) Clear the screen.',0
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
	jmp .cmdEnd
	
	.comm:
	
	call ConsoleClear
	
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_EMP:
	db 'EMP',0
str_cmdh_EMP:
	db ' (?) Hace literalmente nada. xD',0
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
	jmp .cmdEnd
	
	.comm:
	
	; ABSOLUTAMENTE NADA XD
	
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_LIST:
	db 'LIST',0
str_cmdh_LIST:
	db ' (?) List the program in memory.',0
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
	jmp .cmdEnd
	
	.comm:
	
	mov si, 0x9e00
	call PrintString
	; No hace falta PrintLn porque siempre hay un CR al final
	
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_NEW:
	db 'NEW',0
str_cmdh_NEW:
	db ' (?) Clear the program in memory.',0
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
	jmp .cmdEnd
	
	.comm:
	xor bx, bx
	
	call __ensure
	cmp bl, byte 0
	jnz .cmdEnd
	
	mov si, 0x9e00
	.loopi:
		; Limitar
		mov bx, 0xce00
		cmp di, bx ; 0x9e00 + 12KB
		jae .exitLoop
		
		mov bh, byte 0
		cmp bh, [si]
		jz .exitLoop ; Si encuentra un NUL significa que ya ha terminado
		
		mov [si], bh
		
		inc si
		jmp .loopi
	.exitLoop:
	mov [BasicProgramCounter], word 0x9e00
	
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_OFF:
	db 'OFF',0
str_cmdh_OFF:
	db ' (?) Turns off the computer. Use "OFF +" to shut down without prompting.',0
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
	jmp .cmdEnd
	
	.comm:
	
	
	mov bh, byte '+' ; Sin preguntar
	cmp bh, [_InputBuffer+4]
	jz .exitgc
	
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
		
		xor bx, bx ; Todo ok
		jmp .cmdEnd
	.exitgc:
	
	mov si, _str_cc_OFF2
	call PrintString
	
	mov cx, 0x002d ; 3 SECONDS
	mov dx, 0xc6c0
	call _sys_wait
	
	call _sys_shutdown
	
	xor bx, bx ; Todo ok
	.cmdEnd:
	ret

str_cmd_PRE:
	db 'PRE',0
str_cmdh_PRE:
	db ' (?) Change the prefix of the commands (default: "# "). Maximum 6 characters.',0
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
	jmp .cmdEnd
	
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
	jmp .cmdEnd
	
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
	
	.starti2:
	call PrintLn
	mov si, _BRFS_TMS_
	.loop:
		cmp si, _BRFS_TMS_+510
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
	call PrintLn
	
	xor bh, bh
	cmp bh, [si]
	jnz .msg_leermas
	cmp bh, [si+1]
	jnz .msg_leermas
	
	jmp .cmdEndG
	
	
	.msg_leermas:
	mov di, si
	call __more
	cmp bl, byte 0
	jnz .cmdEndG
	
	pusha
	call GetCursorPos
	sub dh, 2
	xor dl, dl
	call SetCursorPos
	mov ah, 0x09
	mov al, ' '
	xor bh, bh
	mov bl, [COLOR]
	mov cx, 0x80
	int 10h
	popa
	
	xor bh, bh
	cmp bh, [di]
	jnz .leermas ; No es 0x0001
	inc bh
	cmp bh, [di+1]
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
	mov bh, [di]
	mov bl, [di+1]
	call _BRFS_ReadSector
	jmp .starti2
	
	.cmdEndB:
	mov si, _str_cc_unkPath
	call PrintStringLn
	jmp .cmdEnd
	.cmdEndG:
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
	jmp .cmdEnd
	
	.comm:
	
	mov si, BasicSpace
	call BasicInterpret
	
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
	jmp .cmdEnd
	
	.comm:
	
	call PrintLn
	mov si, _str_cc_version
	call PrintStringLn
	
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
	call PrintLn
	mov si, _str__MORE
	call PrintStringLn
	
	call GetChar
	cmp al, 13
	jz .exitgc
	
	mov bl, 0x01 ; Ha pulsado otra tecla
	jmp .end
	
	.exitgc:
	
	; Mini Clear
	call GetCursorPos
	mov dh, [_CursorRow]
	sub dh, 2
	xor dl, dl
	call SetCursorPos
	mov ah, 0x09
	mov al, ' '
	xor bh, bh
	mov bl, [COLOR]
	mov cx, 0x80
	int 10h
	
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
_str_cc_Unk:
	db ' -- Este comando no esta terminado xD --',0
_str_cc_version:
	db ' FreeBASIC 0.1.1        published under GPL 3 license.',13
	db 13
	db ' > System               by Bruno Castro',13
	db '   version 0.1          [bruno@retronomicon.gq]',13
	db 13
	db ' > Basic Interpreter    by Angel Ruiz Fernandez',13
	db '   version 0.1          [aruizfernandez05@gmail.com]',13
	
	db 0
_str__ensure:
	db 'Sure? Press ENTER to confirm.',0
_str__OK:
	db 'Ok!',0
_str__MORE:
	db ' --- MORE ---',0