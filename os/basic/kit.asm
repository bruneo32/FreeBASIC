_PrintString		equ 0x7f00
_PrintLn			equ 0x7f02
_PrintStringLn		equ 0x7f04
_GetPromptString	equ 0x7f06
_InputBuffer		equ 0x7f08 ; Return de GetPromptString
__ensure			equ 0x7f0a
__more				equ 0x7f0c


global PrintString
PrintString:
	mov bx, sp
	add bx, 6
	mov si, word [bx] ; Argument 0
	
	call word [_PrintString]
	ret

global PrintLn
PrintLn:
	call word [_PrintLn]
	ret

global PrintStringLn
PrintStringLn:
	mov bx, sp
	add bx, 6
	mov si, word [bx] ; Argument 0
	
	call word [_PrintStringLn]
	
	ret

global GetPromptString
GetPromptString:
	call word [_GetPromptString]
	ret

global _ensure
_ensure:
	call word [__ensure]
	ret

global _more
_more:
	call word [__more]
	ret
