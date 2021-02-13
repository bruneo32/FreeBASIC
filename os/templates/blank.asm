; Entry point
Start:
	call ConsoleClear
	
	mov si, str_hello
	call PrintStringLn
	
	; Return the control to the system
	ret

; System required variables
COLOR:
	db 0x0f
VideoMode:
	db 0x03
str_pretext:
	db ''
	times 6-($-str_pretext) db 0
	db 0
	
; Custom variables
str_hello:
	db 'Welcome!',0