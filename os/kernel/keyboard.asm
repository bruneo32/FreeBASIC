GetPromptString:
	pusha
	call _ClearInputBuffer
	mov bx, _InputBuffer ; Direcction de inicio de _InputBuffer
	
	.strLoop:
		call GetChar
		
		cmp al, 13 ; CR - Enter
		jz .exitLoop
		cmp al, 8 ; Backspace
		jz ._key_backspace
		
		; Verificar si cabe, si no: a chuparla
		cmp bx, _InputBuffer+_InputBufferSize
		ja .continueLoop
		
		
		; Ojo con algunos caracteres
		cmp al, 32 ; SPACE, todos los anteriores son caracteres de control
		jb .continueLoop
		cmp al, 126 ; ~, todos los siguiente
		ja .continueLoop
		
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
			jle .continueLoop
			; Arreglar la memoria (_InputBuffer)
			dec bx
			mov [bx], byte 0
			; Arreglar el display
			mov ah, 0x0e
			int 0x10
			mov al, 0 ; SUPRIMIR
			int 0x10
			mov al, 8 ; IZDA
			int 0x10
			jmp .continueLoop
	
	.exitLoop:
	popa
	; String adress stored in _InputBuffer address
	ret

GetChar:
	mov ah, 01h
	int 16h
	jz GetChar
	
	mov ah, 00h
	int 16h
	
	; Char stored in AL register
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