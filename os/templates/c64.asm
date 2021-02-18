; Entry point
CustomConsole:
	
	; Fill with color
	mov al, ' '
	mov bh, 0x30
	xor cx,cx
	mov dx, 0x2580
	call _AttrRect
	
	call ConsoleClear
	
	; Fill with color
	mov al, ' '
	mov bh, 0x1B
	mov cx, 0x0305
	mov dx, 0x0649
	call _AttrRect
	
	mov si, str_welcome
	call PrintStringLn
	
	; Return the control to the system
	ret

; System required variables
COLOR:
	; See "COLOR ?"
	db 0x1F
SafeRect:
	;  ROW  COL
	db 0x03,0x05 ; Top-left corner
	db 0x15,0x49 ; Bottom-right corner
str_pretext:
	db ''
	times 6-($-str_pretext) db 0
	db 0

; Custom variables
str_welcome:
	db 13,'                   **** COMMODORE 64 BASIC V2 ****',13
	db '               64K RAM SYSTEM  38911 BASIC BYTES FREE',13
	db 'READY.',13
	db 0
