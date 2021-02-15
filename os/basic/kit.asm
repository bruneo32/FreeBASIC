_PrintString        	equ 0x7f00
_PrintLn            	equ 0x7f02
_PrintStringLn        	equ 0x7f04
_GetPromptString    	equ 0x7f06
_InputBuffer        	equ 0x7f08 ; Return de GetPromptString
_ClearInputBuffer   	equ 0x7f0a
__ensure            	equ 0x7f0c
__more                	equ 0x7f0e
_ExtendedStore        	equ 0x7f10
_ExtendedRead        	equ 0x7f12


global PrintString
PrintString:
    mov bx, sp
    mov si, word [bx-2] ; Argument 0
    
    call word [_PrintString]
    ret

global PrintLn
PrintLn:
    call word [_PrintLn]
    ret

global PrintStringLn
PrintStringLn:
    mov bx, sp
    mov si, word [bx-2] ; Argument 0
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
    mov si, word [bx-4] ; Argument 0
    mov bx, sp
    xor al, al
    mov al, byte [bx-2] ; Argument 1
    
    call word [_ExtendedStore]
    ret

global ExtendedRead
ExtendedRead:
    mov bx, sp
    mov si, word [bx-2] ; Argument 0
    
    call word [_ExtendedRead]
    
    ; Return in AL
    xor ah, ah
    ret