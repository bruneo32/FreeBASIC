_strcmp:
	; ARG 0 : SI
	; ARG 1 : DI
	; IgnoreCase: if ==byte 1
	
	; Using BX to compare
	
	.loop:
		mov bh, [si]
		mov bl, [di]
		
		; Ajustar STOPCHAR
		mov dh, [_stopchar]
		cmp bh, dh
		jnz .borraBL
		xor bh, bh
		.borraBL:
		cmp bl, dh
		jnz .finBorra
		xor bl, bl
		.finBorra:
		
		; Comprobar si tiene que Ignorar el CASEcase
		mov dh, [IgnoreCase]
		xor ah, ah
		cmp dh, ah
		jz .yescase
		
		; BH
		mov dh, 'a'
		cmp bh, dh
		jl .casiyescase ; Por algún motivo tienen signo
		mov dh, 'z'
		cmp bh, dh
		jg .casiyescase
		; entonces está entre la a y la z minusculas, convertir a mayuscula
		sub bh, 32
		
		.casiyescase:
		; BL
		mov dh, 'a'
		cmp bl, dh ; a, minuscula
		jl .yescase
		mov dh, 'z'
		cmp bl, dh ; z, minuscula
		jg .yescase
		; entonces está entre la a y la z minusculas, convertir a mayuscula
		sub bl, 32
		
		
		.yescase:
		
		; comparar
		cmp bh, bl
		jz .next ; ZFlag if cmp is ==
		; NOT EQUAL
		mov bh, 0x01
		jmp .exitloop
		
		.next:
		; verificar final de cadena
		cmp bh, byte 0
		jz .exitloop
		
		; Siguientes
		inc si
		inc di
		
		jmp .loop
	.exitloop:
	
	; Return 0 if they are equals! else 1
	ret

StringCompareCustom:
	; BH == (byte) caracter de parada. Pero se destruirá
	; If CF, ignore case
	mov [_stopchar], bh
	mov [IgnoreCase], byte 0 ; Case Sensitive
	call _strcmp
	ret

StringCompare:
	mov [_stopchar], byte 0
	mov [IgnoreCase], byte 0
	call _strcmp
	ret
StringCompareSpace:
	mov [_stopchar], byte 32 ; SPACE
	mov [IgnoreCase], byte 0
	call _strcmp
	ret
StringCompareComma:
	mov [_stopchar], byte ','
	mov [IgnoreCase], byte 0
	call _strcmp
	ret

iStringCompare:
	mov [_stopchar], byte 0
	mov [IgnoreCase], byte 1
	call _strcmp
	ret
iStringCompareSpace:
	mov [_stopchar], byte 32 ; SPACE
	mov [IgnoreCase], byte 1
	call _strcmp
	ret
iStringCompareComma:
	mov [_stopchar], byte ','
	mov [IgnoreCase], byte 1
	call _strcmp
	ret


; vars
IgnoreCase:
	db 0
_stopchar:
	db 0