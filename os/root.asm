sector18: ; 0x0012
	db 'Hola, buenos dias'
	
	times 510-($-sector18) db 0
	dw 0 ; Puntero