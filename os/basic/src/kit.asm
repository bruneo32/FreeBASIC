_PrintString			equ 0x1100
_PrintLn				equ 0x1102
_PrintStringLn			equ 0x1104
_GetPromptString		equ 0x1106
_InputBuffer			equ 0x1108 ; Return de GetPromptString
_ClearInputBuffer		equ 0x110a
__ensure				equ 0x110c
__more					equ 0x110e
_ExtendedStore			equ 0x1110
_ExtendedLoad			equ 0x1112
BasicProgramCounter		equ 0x1114
MainLoop				equ 0x1116

global _InputBuffer
global BasicProgramCounter

global PrintString
PrintString:
	mov bx, sp
	mov si, word [bx+2] ; Argument 0
	
	call word [_PrintString]
	ret

global PrintLn
PrintLn:
	call word [_PrintLn]
	ret

global PrintStringLn
PrintStringLn:
	mov bx, sp
	mov si, word [bx+2] ; Argument 0
	
	call word [_PrintStringLn]
	
	ret

global GetPromptString
GetPromptString:
	call word [_GetPromptString]
	ret

global ClearInputBuffer
ClearInputBuffer:
	call word [_ClearInputBuffer]
	ret

global _ensure
_ensure:
	call word [__ensure]
	; Return BL
	xor ah, ah
	mov al, bl
	ret

global _more
_more:
	call word [__more]
	; Return BL
	xor ah, ah
	mov al, bl
	ret

global ExtendedStore
ExtendedStore:
	mov bx, sp
	mov si, word [bx+2] ; Argument 0
	xor ah, ah
	mov al, byte [bx+4] ; Argument 1
	
	call word [_ExtendedStore]
	ret

global ExtendedLoad
ExtendedLoad:
	mov bx, sp
	mov si, word [bx+2] ; Argument 0
	
	call word [_ExtendedLoad]
	
	; Return in AL
	xor ah, ah
	ret