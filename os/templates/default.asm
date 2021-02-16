; Entry point
CustomConsole:
	call ConsoleClear
	
	mov si, str_welcome
	call PrintStringLn
	
	; Return the control to the system
	ret

; System required variables
COLOR:
	; See "COLOR ?"
	db 0x1f
SafeRect:
	;  ROW  COL
	db 0x00,0x00 ; Top-left corner
	db 0x25,0x80 ; Bottom-right corner
str_pretext:
	db '# '
	times 6-($-str_pretext) db 0
	db 0

; Custom variables
str_welcome:
	db 13 ; Salto de linea
	times 80/2-4 db ' ' ; Tamaño de la pantalla/2 - string.length/2
	db 'FreeBASIC'
	db 13,0
