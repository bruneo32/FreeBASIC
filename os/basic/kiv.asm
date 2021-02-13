_PrintString		equ 0x7f00
_PrintLn			equ 0x7f02
_PrintStringLn		equ 0x7f04
_GetPromptString	equ 0x7f06
_InputBuffer		equ 0x7f08 ; Return de GetPromptString
__ensure			equ 0x7f0a
__more				equ 0x7f0c


global PrintString
PrintString:
	mov si, word [bp-2] ; Argument 0
	call word [_PrintString]
	ret

global PrintLn
PrintLn:
	call word [_PrintLn]
	ret

global PrintStringLn
PrintStringLn:
	mov si, word [bp-2] ; Argument 0
	call word [_PrintStringLn]
	ret
