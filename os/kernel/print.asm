PrintLn:
	pusha
	mov ah, 0x0e
	xor bx, bx
	mov al, 0x0d
	int 0x10
	mov al, 0x0a
	int 0x10
	popa
	ret

PrintString:
	; SI: String adress
	pusha
	mov ah, 0x0e
	.loop:
		cmp [si], byte 0
		jz .exitloop
		
		mov bh, 0x0d
		cmp bh, [si]
		jz .crlf
		
		jmp .print
		
		.crlf:
		mov al, 0x0a ; LF
		int 0x10
		.print:
		mov al, [si]
		xor bx, bx
		int 0x10
		
		.next:
		inc si
		jmp .loop
	.exitloop:
	popa
	ret
PrintStringLn:
	; SI: String adress
	call PrintString
	call PrintLn
	ret

SetCursorPos:
	; DH: Row
	; DL: Column
	pusha
	
	mov ax, 0x0200
	xor bx, bx ; Page
	int 10h
	; Registers destroyed:      AX, SP, BP, SI, DI
	
	popa
	ret
GetCursorPos:
	pusha
	
	mov ax, 0x0300
	xor bx, bx ; Page
	int 10h
	; Registers destroyed:      AX, SP, BP, SI, DI
	; Return DH:ROW, DL:COLUMN
	mov [_CursorRow], dh
	mov [_CursorCol], dl
	
	popa
	ret
MovCursorRel:
	; BH: Row more
	; BL: Column more
	push dx
	
	call GetCursorPos
	mov dh, [_CursorRow]
	mov dl, [_CursorCol]
	add dh, bh
	add dl, bl
	call SetCursorPos
	
	pop dx
	ret

_CursorRow: db 0
_CursorCol: db 0