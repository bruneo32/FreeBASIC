str_cmds:
	db 'Escribe un comando seguido de ? para obtener mas ayuda. Ej.: PRE ?',13
	db 13
	db 'Comandos sobre BASIC:',13
	db ' > LIST, LOAD, NEW, RUN, SAVE',13
	db 13
	db 'Comandos del sistema:',13
	db ' > CLS, COL, HELP, OFF, PRE, VER',13
	db 13
	db 'Comandos sobre archivos:',13
	db ' > CAT, CHD, DEL, DELD, MKD, REN, REND, RTX, WTX',13
	
	db 0
	
str_cmd_HELP:
	db 'HELP',0
str_cmdh_HELP:
	db ' (?) Descubriste un easter egg XD',0
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
	db ' (?) Muestra un listado con todos los elementos del directorio actual',0
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
	
	call PrintLn
	mov si, _str_cc_Unk
	call PrintStringLn
	
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_CLS:
	db 'CLS',0
str_cmdh_CLS:
	db ' (?) Limpia la pantalla',0
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
	db ' (?) Muestra el codigo del programa BASIC en memoria',0
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
	call PrintStringLn
	
	xor bx, bx
	.cmdEnd:
	ret

str_cmd_OFF:
	db 'OFF',0
str_cmdh_OFF:
	db ' (?) Apaga el sistema. Utiliza "OFF +" para apagar sin preguntar.',0
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
	db ' (?) Cambia el prefijo de los comandos (por defecto: "# "). Maximo 6 caracteres.',0
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

str_cmd_VER:
	db 'VER',0
str_cmdh_VER:
	db ' (?) Muestra informacion de la version actual de BrunOS.',0
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


; Strings
_str_cc_OFF:
	db 0x0d,'> Pulsa ENTER para apagar, o cualquier otra tecla para cancelar.', 0
_str_cc_OFF2:
	db '> Apagando...',0
_str_cc_Unk:
	db ' -- Este comando no esta terminado xD --',0
_str_cc_unkPath:
	db 'No existe la ruta',0
_str_doclsto:
	db 'OK! Usa CLS para ver los cambios',0
_str_cc_version:
	db ' FreeBASIC 0.1 bajo la licencia GPL3',0
_str_cc_rtx_readmore:
	db 0x0d,' --- ENTER para seguir leyendo ---',0
_str_cc_yaex:
	db 'Ya existe un elemento con ese nombre',0