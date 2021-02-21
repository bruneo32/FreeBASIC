x001d:
	db 'Hola, buenos dias.',32
	
	times 510-($-x001d) db 0
	db 0,0x21 ; Puntero

x001e:
	db '..',0x1d,0x00,0x01
	db 'example.bas',0x1c,0x00,0x1f
	db 'assembly.prg',0x1c,0x00,0x20
	db '1.tmp',0x1c,0x00,0x24
	db '2.tmp',0x1c,0x00,0x25
	
	times 510-($-x001e) db 0
	db 0x00,0x22

x001f:
	db '10 PRINT "Hello"',13
	db '20 PRINT "World!"',13
	db '999 END',13
	
	times 510-($-x001f) db 0
	dw 0 ; Puntero

x0020:
	incbin "programs/probinha.prg"
	
	times 510-($-x0020) db 0
	dw 0 ; Puntero

x0021:
	db 'Mucho respeto.',13
	
	times 510-($-x0021) db 0
	db 0x00,0x23

x0022:
	db 'Resp',0x1c,0x00,0x21
	
	times 510-($-x0022) db 0
	dw 0 ; Puntero

x0023:
	db 'Pase buen dia'
	
	times 510-($-x0023) db 0
	dw 0 ; Puntero

x0024:
	db 'COLOR 02',13
	db 'PRE ]',13
	db 'SAVERECT 0,0,25,80',13
	db 'PRT APPLE ]['
	
	times 510-($-x0024) db 0
	dw 0 ; Puntero

x0025:
	db 'COLOR 1f',13
	db 'PRE',13
	db 'SRECT 03,05,15,49',13
	db 'RECT 33,00,00,19,45',13
	db 'CLS',13
	db 'ARECT 1B,03,05,06,49',13
	db 'PRT',13
	db 'PRT                    **** COMMODORE 64 BASIC V2 ****',13
	db 'PRT                64K RAM SYSTEM  38911 BASIC BYTES FREE',13
	db 'READY.'
	
	times 510-($-x0025) db 0
	dw 0 ; Puntero

times 4*512 db 0