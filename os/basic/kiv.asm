_PrintString		equ 0x7d00
_PrintLn			equ 0x7d02
_PrintStringLn		equ 0x7d04
_GetPromptString	equ 0x7d06
_InputBuffer		equ 0x7d08 ; Return de GetPromptString

global PrintString
PrintString:
	mov bx, sp
	add bx, 4
	mov si, [bx]
	call 0:_PrintString
	ret

global PrintLn
PrintLn:
	call 0:_PrintLn
	ret

global PrintStringLn
PrintStringLn:
	mov bx, sp
	add bx, 4
	mov si, [bx]
	call 0:_PrintStringLn
	ret
	
global GetPromptString
GetPromptString:
	call 0:_GetPromptString
	; Return a NUL terminated string in _InputBuffer
	ret