Start:
	; Video mode 3
	; 80 cols, 25 rows
	
	call ConsoleClear
	
	mov si, str_welcome
	call PrintStringLn
	ret

ConsoleClear:
	call ConsoleClearSimple
	; mov al, 0x01 ; 40x25
	; mov bh, [COLOR]
	; xor cx, cx
	; call ConsoleClearAdvanced
	ret

COLOR:
	db 0x02 ; Verde brillante, mejor que 0x02 que es verde culo jajaj
str_pretext:
	db '] ',0
	times 6-($-str_pretext) db 0
	db 0

str_welcome:
	db 13 ; Salto de linea
	times 80/2-4 db ' ' ; Tamaño de la pantalla/2 - string.length/2
	db 'APPLE ][' ; length=8
	db 13
	db 0
