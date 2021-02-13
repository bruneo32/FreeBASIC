__SECRETGAME__:
	; Hide cursor
	mov dx, 0x2580
	call SetCursorPos
	
	mov bx, word 1
	push bx
	
	.preloop1:
	mov cx, word 25 ; Screen height
	.loop1:
		cmp cx, word 0
		jz .exitLoop1
		push cx
		
		call .bajar
		
		mov cx, 300
		call Sleep
		
		pop cx
		dec cx
		jmp .loop1
	
	.bajar:
		mov ax, 0x0701 ; Hacia abajo, 1 row
		mov bh, [COLOR]
		xor bl, bl
		xor cx, cx
		mov dx, 0x2580
		int 10h
		ret
	
	.exitLoop1:
	pop bx
	cmp bx, byte 0
	jz .end
	
	call SetCursorPos
	
	xor cx, cx ; Screen height
	.loop2:
		cmp cx, word 14*3
		jae .exitLoop2
		
		push cx
		
		xor dh, dh
		mov dl, 0x06
		call SetCursorPos
		
		add cx, __SG_BASIC_STR
		mov si, cx
		call PrintString
		
		call .bajar
		
		mov cx, 300
		call Sleep
		
		pop cx
		add cx, 14
		jmp .loop2
	.exitLoop2:
	xor bx, bx
	push bx
	jmp .preloop1
	
	.end:
	ret


__SG_BASIC_STR:
	db 200,205,188,202,32,202,200,205,188,202,200,205,188,0
	db 204,202,187,204,205,185,200,205,187,186,186,32,32,0
	db 201,187,32,201,205,187,201,205,187,203,201,205,187,0

	; ╔╗ ╔═╗╔═╗╦╔═╗
	; ╠╩╗╠═╣╚═╗║║  
	; ╚═╝╩ ╩╚═╝╩╚═╝