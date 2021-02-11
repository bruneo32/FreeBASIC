_PrintStringLn equ 0x7d00

global PrintStringLn
PrintStringLn:
	mov bx, sp
	add bx, 4
	mov si, [bx]
	call _PrintStringLn
	ret