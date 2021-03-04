ExtendedStore:
	; [0xFFFF+1+SI] = AL
	
	push bx
	push si
	
	mov bx, 0xFFFF
	inc si
	
	mov byte [bx+si], al
	
	pop si
	pop bx
	ret
ExtendedLoad:
	; AL = [0xFFFF+1+SI]
	
	push bx
	push si
	
	mov bx, 0xFFFF
	inc si
	
	mov al, byte [bx+si]
	
	pop si
	pop bx
	ret