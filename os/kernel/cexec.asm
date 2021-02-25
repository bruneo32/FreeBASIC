_con_exec:

	clc
	
	; No hay comando, truhan
	mov si, _InputBuffer
	cmp [si], byte 0
	jz .end
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;
	; Cosas de comandos
	
	;	HELP
	mov si, _InputBuffer
	mov di, str_cmd_HELP
	call iStringCompareSpace
	call cmd_HELP
	cmp bh, byte 0 ; Rutina
	jz .end
	
	
	;	ARECT
	mov si, _InputBuffer
	mov di, str_cmd_ARECT
	call iStringCompareSpace
	call cmd_ARECT
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	CAT
	mov si, _InputBuffer
	mov di, str_cmd_CAT
	call iStringCompareSpace
	call cmd_CAT
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	CD
	mov si, _InputBuffer
	mov di, str_cmd_CD
	call iStringCompareSpace
	call cmd_CD
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	CDT
	mov si, _InputBuffer
	mov di, str_cmd_CDT
	call iStringCompareSpace
	call cmd_CDT
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	CLS
	mov si, _InputBuffer
	mov di, str_cmd_CLS
	call iStringCompareSpace
	call cmd_CLS
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	COLOR
	mov si, _InputBuffer
	mov di, str_cmd_COLOR
	call iStringCompareSpace
	call cmd_COLOR
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	COM
	mov si, _InputBuffer
	mov di, str_cmd_COM
	call iStringCompareSpace
	call cmd_COM
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	DSK
	mov si, _InputBuffer
	mov di, str_cmd_DSK
	call iStringCompareSpace
	call cmd_DSK
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	DSKDAT
	mov si, _InputBuffer
	mov di, str_cmd_DSKDAT
	call iStringCompareSpace
	call cmd_DSKDAT
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	FRECT
	mov si, _InputBuffer
	mov di, str_cmd_FRECT
	call iStringCompareSpace
	call cmd_FRECT
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	FORMAT
	mov si, _InputBuffer
	mov di, str_cmd_FORMAT
	call iStringCompareSpace
	call cmd_FORMAT
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	INF
	mov si, _InputBuffer
	mov di, str_cmd_INF
	call iStringCompareSpace
	call cmd_INF
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	INFD
	mov si, _InputBuffer
	mov di, str_cmd_INFD
	call iStringCompareSpace
	call cmd_INFD
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	MEM
	mov si, _InputBuffer
	mov di, str_cmd_MEM
	call iStringCompareSpace
	call cmd_MEM
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	NEW
	mov si, _InputBuffer
	mov di, str_cmd_NEW
	call iStringCompareSpace
	call cmd_NEW
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	LD
	mov si, _InputBuffer
	mov di, str_cmd_LD
	call iStringCompareSpace
	call cmd_LD
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	LIST
	mov si, _InputBuffer
	mov di, str_cmd_LIST
	call iStringCompareSpace
	call cmd_LIST
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	LOAD
	mov si, _InputBuffer
	mov di, str_cmd_LOAD
	call iStringCompareSpace
	call cmd_LOAD
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	OFF
	mov si, _InputBuffer
	mov di, str_cmd_OFF
	call iStringCompareSpace
	call cmd_OFF
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	PRE
	mov si, _InputBuffer
	mov di, str_cmd_PRE
	call iStringCompareSpace
	call cmd_PRE
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	PRG
	mov si, _InputBuffer
	mov di, str_cmd_PRG
	call iStringCompareSpace
	call cmd_PRG
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	PRT
	mov si, _InputBuffer
	mov di, str_cmd_PRT
	call iStringCompareSpace
	call cmd_PRT
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	RTX
	mov si, _InputBuffer
	mov di, str_cmd_RTX
	call iStringCompareSpace
	call cmd_RTX
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	RUN
	mov si, _InputBuffer
	mov di, str_cmd_RUN
	call iStringCompareSpace
	call cmd_RUN
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	SRECT
	mov si, _InputBuffer
	mov di, str_cmd_SRECT
	call iStringCompareSpace
	call cmd_SRECT
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	SYS
	mov si, _InputBuffer
	mov di, str_cmd_SYS
	call iStringCompareSpace
	call cmd_SYS
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	VER
	mov si, _InputBuffer
	mov di, str_cmd_VER
	call iStringCompareSpace
	call cmd_VER
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	WTX
	mov si, _InputBuffer
	mov di, str_cmd_WTX
	call iStringCompareSpace
	call cmd_WTX
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	; mov si, _InputBuffer
	; call BasicInterpret
	
	;	No command.
	mov si, _str_nocom
	call PrintStringLn
	stc ; ERROR NO EXITE :V
	
	.end:
	ret

_bas_store:
	xor bx, bx
	mov si, _InputBuffer
	mov di, word [BasicProgramCounter]
	.loop:
		; Limitar
		mov bx, ProgramSpace
		cmp di, bx
		jae .error
		
		
		; Comprobar si==NUL
		mov bh, byte 0
		cmp bh, [si]
		jz .storeCR
		
		mov bh, [si]
		mov [di], bh
		
		inc si
		inc di
		jmp .loop
	.exitLoop:
	jmp .end
	
	.storeCR:
		; Ojete con pasarse del Buffer
		mov bx, ProgramSpace
		cmp di, bx ; 0x9e00 + 12KB
		jae .error
		
		mov bh, 0x0d ; CR
		mov [di], bh
		
		inc di
		jmp .end
	
	.error:
	; Te pasaste de y ya no te permito más,
	; porque este es el sector de memoria de otra cosa.
	; Mejor haz un NEW
	mov si, _str_basicoverflow
	call PrintStringLn
	mov di, 0xffff
	
	.end:
	mov word [BasicProgramCounter], di
	
	ret

TryCommandOrBas:
	;; Uncomment this block to debug the keyboard buffer.
	; mov si, _InputBuffer
	; call PrintStringLn
	; ret
	
	; Verificar si es un numero hasta el SPACE
	
	mov si, _InputBuffer
	.loop:
		; Si encuentra un NUL o un SPACE
		mov bx, 0x0020 ; BH:NUL | BL:SPACE (20h)
		cmp [si], bh ; [SI]==00, fin del string siendo solo un numero, entonces tenemos que borrar esa linea.
		jz .bas
		cmp [si], bl ; [SI]==SPACE, asi que todo bien, vamos a ejecutar el BASIC
		jz .bas
		
		; Verificar si no es un numero
		mov bh, byte '0'
		mov bl, byte '9'
		cmp [si], bh
		jb .com
		cmp [si], bl
		ja .com
		
		inc si
		jmp .loop
	.exitLoop:
	; Si sale por aqui es que era un numero
	
	.bas:
	; Basic store
	call _bas_store
	jmp .end
	
	.com:
	; Commando
	call _con_exec
	
	.end:
	ret

_str_basicoverflow:
	db '[ERROR] BASIC program overflow, you exceded 12KB and reached 0xDA00.',0

_str_nocom:
	db '[Error] Unknown or invalid command.',0