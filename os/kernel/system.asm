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
_sys_get_date:
	mov ah, 0x04
	int 1ah
	jc .end
	; CH         Century (19 or 20) (BCD)
	; CL         Year (BCD)
	; DH         Month (BCD)
	; DL         Day (BCD)
	push bx
	
	mov di, _sys_date
	
	; YEAR
	xor bx, bx
	mov bl, ch ; YEAR Upper
	shl bx, 4
	shr bl, 4
	add bh, '0' ; Convertir a ASCII
	add bl, '0' ; Convertir a ASCII
	
	mov [di], bh
	inc di
	mov [di], bl
	inc di
	
	; YEAR 2
	xor bx, bx
	mov bl, cl ; YEAR Lower
	shl bx, 4
	shr bl, 4
	add bh, '0' ; Convertir a ASCII
	add bl, '0' ; Convertir a ASCII
	
	mov [di], bh
	inc di
	mov [di], bl
	inc di
	
	; Ignorar una
	inc di
	
	; MES
	xor bx, bx
	mov bl, dh ; MONTH
	shl bx, 4
	shr bl, 4
	add bh, '0' ; Convertir a ASCII
	add bl, '0' ; Convertir a ASCII
	
	mov [di], bh
	inc di
	mov [di], bl
	inc di
	
	; Ignorar una
	inc di
	
	; DIA
	xor bx, bx
	mov bl, dl ; DAY
	shl bx, 4
	shr bl, 4
	add bh, '0' ; Convertir a ASCII
	add bl, '0' ; Convertir a ASCII
	
	mov [di], bh
	inc di
	mov [di], bl
	inc di
	
	
	pop bx
	.end:
	ret

_mem_copy:
	; SI: Source address
	; DI: Destination address
	; BX: Count
	pusha
	mov cx, bx
	.loop:
		cmp cx, byte 0
		jz .exitLoop
		
		mov dh, [si]
		mov byte [di], dh
		
		inc di
		inc si
		dec cx
		jmp .loop
	.exitLoop:
	
	popa
	ret

_sys_wait:
	; MICROSEGUNDOS
	; CX: HIGH
	; DX: LOW
	mov ax, 0x8600
	int 15h
	ret

Sleep:
	pusha
	; CX: Sleep in milliseconds
	mov ax, 1000
	mul cx
	; Return DX:AX = source * AX
	mov cx, dx
	mov dx, ax
	call _sys_wait
	popa
	ret

_sys_shutdown:
	; APM
    mov ax, 0x1000
    mov ax, ss
    mov sp, 0xf000
    mov ax, 0x5307
    mov bx, 0x0001
    mov cx, 0x0003
    int 0x15
	jc .error
	
	mov cx, 0x2200
	call Sleep
	
	; ACPI (if APM didnt work)
	
	.shutdown_sucess:
	mov ax, 5301h           		 ; Connect to the APM
	xor bx, bx
	int 15h
	je .continue_connection     	 ; Pass if connected
	cmp ah, 2
	je .continue_connection      	 ; Pass if already connected
	jmp .error
	
	.continue_connection:
	mov ax, 530Eh            		 ; Check APM Version
	xor bx, bx
	mov cx, 0102h           		 ; v1.2 Required
	int 15h
	jc .error
	
	jmp .end
	
	.error:
	call PrintLn
	call PrintLn
	mov si, _sys_offnt
	call PrintStringLn
	
	.end:
	jmp word [0x1116] ; Exit

; DATOS
_sys_time:
	db '00:00'
	db 0
_sys_date:
	db '0000-00-00'
	db 0
_sys_offnt:
	db 'It was impossible to shut down the computer. Press and hold the POWER key for a few seconds to power off.',0