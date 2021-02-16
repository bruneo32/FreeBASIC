_con_clear:
	; Clear
	
	; Fill with char ' '
	mov al, ' '
	mov bh, [COLOR]
	mov ch, byte [SafeRect]
	mov cl, byte [SafeRect+1]
	mov dh, byte [SafeRect+2]
	mov dl, byte [SafeRect+3]
	call _AttrRect
	
	ret

ConsoleClear:
	; This is for commands in FreeBASIC
	call _con_clear
	
	call _FillColor
	
	mov dh, byte [SafeRect]
	mov dl, byte [SafeRect+1]
	call SetCursorPos
	
	ret

_FillColor:
	
	; Fill with color
	xor al,al
	mov bh, [COLOR]
	mov ch, byte [SafeRect]
	mov cl, byte [SafeRect+1]
	mov dh, byte [SafeRect+2]
	mov dl, byte [SafeRect+3]
	call _AttrRect
	
	ret