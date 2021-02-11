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
	mov ax, 0x0200
	xor bx, bx ; Page
	int 10h
	; Registers destroyed:      AX, SP, BP, SI, DI
	ret
GetCursorPos:
	mov ax, 0x0300
	xor bx, bx ; Page
	int 10h
	; Registers destroyed:      AX, SP, BP, SI, DI
	; Return DH:ROW, DL:COLUMN
	ret
