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

global _End
_End:
	jmp word [MainLoop]

global miniChar
MiniChar:
	; Iniciar el ARG a 0
	xor al, al

	; Verificar si se pulsa alguna tecla (si no: .end)
	mov ah, 01h
	int 16h
	jz .end

	; Si se pulsa, obtener en AL
	xor ah, ah
	int 16h

	.end:
	; Devuelve el char en AL. Si es 0, no se ha pulsado ninguna tecla
	ret

global CheckEndKey
CheckEndKey:
	; Iniciar el ARG a 0
	xor al, al

	; Verificar si se pulsa alguna tecla (si no: .end)
	mov ah, 01h
	int 16h
	jz .end

	; Si se pulsa, obtener en AH:AL
	xor ah, ah
	int 16h

	; END scancode= 4700

	cmp al, byte 0
	jnz .end
	cmp ah, byte 0x47
	jnz .end

	; Return true
	mov al, byte 1
	ret

	.end:
	; Return false
	xor al, al
	ret