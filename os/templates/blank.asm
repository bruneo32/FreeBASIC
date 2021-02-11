Start:
	call ConsoleClear
	mov si, str_hello
	call PrintStringLn
	
	ret

ConsoleClear:
	call ConsoleClearSimple
	ret

; Vars
str_pretext:
	db '',0
COLOR:
	db 0x0f
str_hello:
	db 'Welcome!',0