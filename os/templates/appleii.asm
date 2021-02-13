; Entry point
Start:
	call ConsoleClear
	
	mov si, str_welcome
	call PrintStringLn
	
	; Return the control to the system
	ret

; System required variables
COLOR:
	db 0x1f ; Verde brillante, mejor que 0x02 que es verde culo jajaj
VideoMode:
	db 0x03
str_pretext:
	db '] '
	times 6-($-str_pretext) db 0
	db 0

; Custom variables
str_welcome:
	db 13 ; Salto de linea
	times 80/2-4 db ' ' ; Tamaño de la pantalla/2 - string.length/2
	db 'APPLE //e' ; length=8
	db 13
	db 0
