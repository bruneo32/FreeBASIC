sector18: ; 0x0012
	db 'Hola, buenos dias'
	
	times 510-($-sector18) db 0
	dw 0 ; Puntero

sector19: ; 0x0013
	db '..',0x1d,0x00,0x01
	db 'example.bas',0x1c,0x00,0x14
	db 'assembly.sys',0x1c,0x00,0x15
	
	times 510-($-sector19) db 0
	dw 0 ; Puntero

sector20: ; 0x0014
	db '10 PRINT "Hello"',13
	db '20 PRINT "World!"',13
	db '999 END',13
	
	times 510-($-sector20) db 0
	dw 0 ; Puntero

sector21: ; 0x0015
	mov si, sector18
	call 0:0x7d00 ; PrintString
	call 0:0x7d0a ; __ensure
	cmp bl, byte 0
	jz sector21
	ret
	
	times 510-($-sector21) db 0
	dw 0 ; Puntero