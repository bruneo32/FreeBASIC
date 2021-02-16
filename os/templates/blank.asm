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
	db 0x0f
SafeRect:
	;  ROW  COL
	db 0x00,0x00 ; Top-left corner
	db 0x25,0x80 ; Bottom-right corner
str_pretext:
	db ''
	times 6-($-str_pretext) db 0
	db 0

; Custom variables
str_welcome:
	db 13,'   Welcome!',13
	db 0
