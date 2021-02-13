ConsoleClear:
	;;; INPUT ;;;
	; Color en [COLOR]
	
	; Clear
	xor ah, ah ; Set video mode
	mov al, [VideoMode]
	int 10h
	
	call _FillColor
	
	ret
_FillColor:
	
	; Fill with color
	mov ax, 0x0600 ; Clear screen
	mov bh, [COLOR]
	xor bl, bl
	xor cx, cx
	mov dx, 0x2580
	int 10h
	
	ret