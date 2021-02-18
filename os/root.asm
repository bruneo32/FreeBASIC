x001c:
	db 'Hola, buenos dias.',32
	
	times 510-($-x001c) db 0
	db 0,0x20 ; Puntero

x001d:
	db '..',0x1d,0x00,0x01
	db 'example.bas',0x1c,0x00,0x1e
	db 'assembly.prg',0x1c,0x00,0x1f
	
	times 510-($-x001d) db 0
	dw 0 ; Puntero

x001e:
	db '10 PRINT "Hello"',13
	db '20 PRINT "World!"',13
	db '999 END',13
	
	times 510-($-x001e) db 0
	dw 0 ; Puntero

x001f:
	incbin "programs/probinha.prg"
	
	times 510-($-x001f) db 0
	dw 0 ; Puntero

x0020:
	db 'Mucho respeto'
	
	times 510-($-x0020) db 0
	dw 0 ; Puntero