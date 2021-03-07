x0027:
	db 'Hola, buenos dias.',32
	
	times 510-($-x0027) db 0
	db 0,0x2c ; Puntero

x0028:
	db '..',0x1d,0x00,0x01
	db 'example.bas',0x1c,0x00,0x2d
	db 'assembly.prg',0x1c,0x00,0x2e
	
	times 510-($-x0028) db 0
	db 0x00,0x2b

x0029:
	db 'COLOR 02',13
	db 'PRE ] ',13
	db 'SRECT 00,00,18,4F',13
	db 'CLS',13
	db 'PRT',13
	db 'PRT                                      APPLE ]['
	
	times 510-($-x0029) db 0
	dw 0 ; Puntero

x002a:
	db 'COLOR 1F',13
	db 'PRE',13
	db 'SRECT 03,05,15,4A',13
	db 'FRECT 00,00,19,4F,30',13
	db 'CLS',13
	db 'PRT',13
	db 'PRT                     **** COMMODORE 64 BASIC V2 ****',13
	db 'PRT                  64K RAM SYSTEM  38911 BASIC BYTES FREE',13
	db 'PRT READY.',13
	db 'ARECT 03,05,06,4A,1B'
	
	times 510-($-x002a) db 0
	dw 0 ; Puntero

x002b:
	db 'Resp',0x1c,0x00,0x2c
	
	times 510-($-x002b) db 0
	dw 0 ; Puntero

x002c:
	db 'Mucho respeto.',13
	
	times 510-($-x002c) db 0
	db 0x00,0x2f

x002d:
	db '10 PRINT "Hello"',13
	db '20 PRINT "World!"',13
	db '999 END',13
	
	times 510-($-x002d) db 0
	dw 0 ; Puntero

x002e:
	incbin "programs/probinha.prg"
	
	times 510-($-x002e) db 0
	dw 0 ; Puntero

x002f:
	db 'Pase buen dia'
	
	times 510-($-x002f) db 0
	dw 0 ; Puntero

x0030:
	db 'COLOR 1F',13
	db 'PRE # ',13
	db 'SRECT 00,00,18,4F',13
	db 'CLS',13
	db 'PRT',13
	db 'PRT                                     FreeBASIC'
	
	times 510-($-x0030) db 0
	dw 0 ; Puntero

x0031:
	db 'REM This command file is executed on the system start.',13
	db 13
	db 'CMD default.tmp',13
	
	times 510-($-x0031) db 0
	dw 0 ; Puntero

times 4*512 db 0

