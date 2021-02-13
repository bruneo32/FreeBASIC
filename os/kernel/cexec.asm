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
	
	;	NEW
	mov si, _InputBuffer
	mov di, str_cmd_NEW
	call iStringCompareSpace
	call cmd_NEW
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	LIST
	mov si, _InputBuffer
	mov di, str_cmd_LIST
	call iStringCompareSpace
	call cmd_LIST
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
	
	;	VER
	mov si, _InputBuffer
	mov di, str_cmd_VER
	call iStringCompareSpace
	call cmd_VER
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
		mov bx, 0xce00
		cmp di, bx ; 0x9e00 + 12KB
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
		mov bx, 0xce00
		cmp di, bx ; 0x9e00 + 12KB
		jae .error
		
		mov bh, 0x0d ; CR
		mov [di], bh
		
		inc di
		jmp .end
	
	.error:
	; Te pasaste de 12KB y ya no te permito más,
	; porque este es el sector de memoria de otra cosa.
	; Mejor haz un NEW
	
	.end:
	mov word [BasicProgramCounter], di
	
	ret

TryCommandOrBas:
	
	; Verificar si es un numero hasta el SPACE
	
	mov si, _InputBuffer
	.loop:
		; Si encuentra un NUL o un SPACE
		mov bx, 0x0020 ; BH:NUL | BL:SPACE (20h)
		cmp [si], bh ; [SI]==00, fin del string siendo solo un numero, entonces tenemos que borrar esa linea.
		jz .end
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
	mov si, _InputBuffer
	call _con_exec
	
	.end:
	ret

_str_nocom:
	db '[Error] Unknown or invalid command.',0