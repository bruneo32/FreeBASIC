_con_exec:

	clc
	
	; No hay comando, truhan
	cmp [si], byte 0
	jz .end
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;
	; Cosas de comandos
	
	;	HELP
	push si
	mov di, str_cmd_HELP
	call iStringCompareSpace
	call cmd_HELP
	pop si
	cmp bh, byte 0 ; Rutina
	jz .end
	
	
	;	CLS
	push si
	mov di, str_cmd_CLS
	call iStringCompareSpace
	call cmd_CLS
	pop si
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	LIST
	push si
	mov di, str_cmd_LIST
	call iStringCompareSpace
	call cmd_LIST
	pop si
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	OFF
	push si
	mov di, str_cmd_OFF
	call iStringCompareSpace
	call cmd_OFF
	pop si
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	PRE
	push si
	mov di, str_cmd_PRE
	call iStringCompareSpace
	call cmd_PRE
	pop si
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	RUN
	push si
	mov di, str_cmd_RUN
	call iStringCompareSpace
	call cmd_RUN
	pop si
	cmp bh, byte 0 ; Rutina
	jz .end
	
	;	VER
	push si
	mov di, str_cmd_VER
	call iStringCompareSpace
	call cmd_VER
	pop si
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
	pusha
	
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
	popa
	ret