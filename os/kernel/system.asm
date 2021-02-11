_sys_get_time:
	mov ah, 0x02
	int 1ah
	jc .end
	
	; CH         Hours (BCD)
	; CL         Minutes (BCD)
	; DH         Seconds (BCD)
	; DL         1 if daylight saving time option; else 0
	
	; HORAS
	xor bx, bx
	mov bl, ch
	shl bx, 4
	shr bl, 4
	;and bl, 01111111b ; Eliminar el ultimo bit residual del SAR
	add bh, '0' ; Convertir a ASCII
	add bl, '0' ; Convertir a ASCII
	
	mov [_sys_time], bh
	mov [_sys_time+1], bl
	
	; MINUTOS
	xor bx, bx
	mov bl, cl
	shl bx, 4
	shr bl, 4
	;and bl, 01111111b ; Eliminar el ultimo bit residual del SAR
	add bh, '0' ; Convertir a ASCII
	add bl, '0' ; Convertir a ASCII
	
	mov [_sys_time+3], bh
	mov [_sys_time+4], bl
	
	.end:
	ret

_sys_wait:
	; MICROSEGUNDOS
	; CX: HIGH
	; DX: LOW
	mov ax, 0x8600
	int 15h
	ret

_sys_shutdown:
	mov ax, 0x1000 ; Apagar
	mov ax, ss
	mov sp, 0xf000
	mov ax, 0x5307
	mov bx, 0x0001
	mov cx, 0x0003
	int 0x15
	
	cli
	hlt
	ret

; DATOS
_str_nocom:
	db '[Error] Comando desconocido o invalido.',0
_sys_time:
	db '00:00'
	db 0