ConsoleClearAdvanced:
	;;; INPUT ;;;
	; AL: VBE Video Mode
	; BH: Color
	; CH: Cursor Row
	; CL: Cursor Col
	
	push cx
	
	xor ah, ah ; Set video mode
	int 10h
	
	mov ax, 0x0600 ; Clear screen
	xor bl, bl ; Page
	xor cx, cx
	mov dx, 0xFFFF
	int 10h
	
	pop cx
	mov dx, cx
	call SetCursorPos
	
	ret

ConsoleClearSimple:
	;;; INPUT ;;;
	; Color en [COLOR]
	mov al, 0x03
	mov bh, [COLOR]
	xor cx, cx
	call ConsoleClearAdvanced
	
	ret