GetPromptString:
	call _ClearInputBuffer
	mov bx, _InputBuffer ; Direcction de inicio de _InputBuffer
	
	.strLoop:
		push bx
		push cx
		call GetChar
		pop cx
		pop bx
		
		cmp al, 13 ; CR - Enter
		jz .exitLoop
		cmp al, 8 ; Backspace
		jz ._key_backspace
		
		; Verificar si cabe, si no: a chuparla
		cmp bx, _InputBuffer+_InputBufferSize
		ja .continueLoop
		
		
		; Ojo con algunos caracteres
		cmp al, 32 ; SPACE, todos los anteriores son caracteres de control
		jb ._ctrlChar
		cmp al, 0x7f ; DEL
		jz .continueLoop
		
		; Display
		mov ah, 0x0e
		push bx
		mov bx, 0x0007
		int 0x10
		pop bx
		
		; Store
		mov [bx], al
		inc bx
		
		.continueLoop:
		jmp .strLoop
		
		
		; RUTIS
		._key_backspace:
			cmp bx, _InputBuffer ; No borrar en el 0
			jbe .continueLoop
			; Arreglar la memoria (_InputBuffer)
			dec bx
			mov dl, byte [bx]
			mov [bx], byte 0
			; Arreglar el display
			cmp dl, byte ' '
			jae .uno
			; SPECIAL CHAR DELETES 2
			mov ah, 0x0e
			int 0x10
			mov al, 0 ; SUPRIMIR
			int 0x10
			mov al, 8 ; IZDA
			int 0x10
			.uno:
			mov ah, 0x0e
			int 0x10
			mov al, 0 ; SUPRIMIR
			int 0x10
			mov al, 8 ; IZDA
			int 0x10
			jmp .continueLoop
		._ctrlChar:
			mov dl, al
			mov [bx], al
			inc bx
			mov ah, 0x0e
			mov al, byte '^'
			int 0x10
			add dl, 65
			mov al, dl
			int 0x10
			jmp .continueLoop
	
	.exitLoop:
	; String adress stored in _InputBuffer address
	ret

GetChar:
	mov ah, 01h
	int 16h
	jz GetChar
	
	xor bx,bx
	mov cl, byte 3
	.Aloop:
	mov ah, 02h
	int 16h
	and al, byte 00001000b
	cmp al, 00001000b ; ALT
	jnz .noALT
		
		; Limitar intentos
		cmp cl, byte 0
		jz .exitAloop
		
		; Obtener caracter
		mov ah, 00h
		int 16h
		
		; Verificar
		cmp ah, 0x78 ; 1
		jb .Aloop
		cmp ah, 0x81 ; 0, after 9
		ja .Aloop
		
		; Convertir
		sub ah, 0x77
		cmp ah, 0x0a
		jb .next
		xor ah,ah
		
		.next:
		; Multiplicar por 10 y sumar
		push ax
		mov al, 10d
		mul bl ; Return in AX
		mov bx, ax
		
		pop ax
		add bl, ah
		
		; Siguiente
		dec cl
		jmp .Aloop
	.exitAloop:
	; Guardar
	
	mov al, bl
	jmp .end
	
	
	.noALT:
	; Check CTRL
	mov ah, 02h
	int 16h
	and al, byte 00000100b
	cmp al, 00000100b ; CTRL
	jnz .noCTRL
	
	; Obtener caracter
	mov ah, 00h
	int 16h
	
	; Verificar
	cmp al, 0x01 ; A
	jb .Aloop
	cmp al, 0x1a ; Z
	ja .Aloop
	
	; Convertir
	dec al ; ^A = NUL
	
	jmp .end
	
	.noCTRL:
	mov ah, 00h
	int 16h
	
	; Char stored in AL register
	.end:
	ret

_InputBufferSize equ 300
_InputBuffer:
	times _InputBufferSize db 0
	db 0 ; Absolutamente necesario, indica el final del string. Posicion _InputBuffer+_InputBufferSize+1
_ClearInputBuffer:
	pusha
	mov bx, _InputBuffer
	.loop:
		mov [bx], byte 0
		inc bx
		cmp bx, _InputBuffer+_InputBufferSize
		jb .loop
	popa
	ret