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


StrToHex:
	; SI: STRING address
	pusha
	
	mov di, STRHEX
	.clear:
		cmp di, STRHEX+8
		ja .eclear
		mov [di], byte 0
		inc di
		jmp .clear
	.eclear:
	xor ax, ax
	xor dx, dx
	mov di, STRHEX
	.loop:
		mov dl, [si]
		xor ah, ah
		cmp dl, ah
		jz .exitLoop
		
		mov ax, STRHEX+8
		cmp di, ax ; No más de 9 xd
		ja .exitLoop
		
		mov ah, '0'
		cmp dl, ah
		jb .NOHEX
		mov ah, '9'
		cmp dl, ah
		ja .letra
		;	Numeros
		sub dl, '0'
		
		mov [di], dl
		
		jmp .next
		
		.letra:
		;	Letras
		; paso 1: ignore case
		mov ah, 'f'
		cmp dl, ah
		ja .NOHEX
		mov ah, 'a'
		cmp dl, ah
		jb .letraMAYUS
		; es minus
		sub dl, 32
		
		.letraMAYUS:
		; Verificar si es invalido
		mov ah, 'A'
		cmp dl, ah
		jb .NOHEX
		mov ah, 'F'
		cmp dl, ah
		ja .NOHEX
		sub dl, 'A'
		add dl, 10 ; A=10
		
		mov [di], dl
		
		; Siguiente
		.next:
		inc si
		inc di
		jmp .loop
	
	.NOHEX:
	;ret
	
	.exitLoop:
	popa
	; Return HEX in STRHEX
	ret

; vars
IgnoreCase:
	db 0
_stopchar:
	db 0
STRHEX:
	times 9 db 0 ; 9 digitos
