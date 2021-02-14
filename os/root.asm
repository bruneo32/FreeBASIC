x0018: ; 0x0012
	db 'Hola, buenos dias'
	
	times 510-($-x0018) db 0
	dw 0 ; Puntero

x0019: ; 0x0013
	db '..',0x1d,0x00,0x01
	db 'example.bas',0x1c,0x00,0x1a
	db 'assembly.prg',0x1c,0x00,0x1b
	
	times 510-($-x0019) db 0
	dw 0 ; Puntero

x001a: ; 0x0014
	db '10 PRINT "Hello"',13
	db '20 PRINT "World!"',13
	db '999 END',13
	
	times 510-($-x001a) db 0
	dw 0 ; Puntero

x001b: ; 0x0015
	mov si, x0018
	call word [0x7f04] ; PrintStringLn
	call word [0x7f0a] ; __ensure
	
	ret
	
	times 510-($-x001b) db 0
	dw 0 ; Puntero