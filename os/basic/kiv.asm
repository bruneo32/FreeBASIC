_PrintStringLn equ 0x7d00

global PrintStringLn
PrintStringLn:
	mov si, word [sp+4]
	call _PrintStringLn
	ret